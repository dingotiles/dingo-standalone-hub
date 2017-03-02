class Cluster < ApplicationRecord
  belongs_to :account
  has_one :cluster_etcd, dependent: :destroy
  has_many :cluster_nodes, dependent: :destroy

  before_create :allocate_guid
  after_create :provision_cluster_etcd
  after_commit on: [:update, :destroy] { ClusterBroadcastJob.perform_later self }
  after_commit :cleanup_etcd!, on: [:update, :destroy], if: :dead?

  def update_state_from_nodes!
    running_nodes = cluster_nodes.where.not(state: "missing")
    if running_nodes.empty?
      self.state = "dead"
    else
      all_running = running_nodes.inject(true) {|running, node| running && node.running? }
      if all_running
        self.state = "running"
      else
        self.state = "starting"
      end
    end
    save!
  end

  def self.dashboard
    order('updated_at DESC')
  end

  def dashboard_nodes
    cluster_nodes.order("updated_at DESC").limit(ClustersController.limit_node_events)
  end

  def etcd_namespace
    if cluster_etcd.keypath
      File.join(cluster_etcd.keypath, "/service/")
    else
      "/service/"
    end
  end

  def dead?
    state == "dead"
  end

  private
  def allocate_guid
    self.guid = SecureRandom.hex(10)
    self
  end

  def provision_cluster_etcd
    Rails.logger.info "Cluster#provision_cluster_etcd"
    if ENV['ETCD_BROKER_URI']
      creds = broker_provision_etcd_creds
    elsif ENV['ETCD_URI']
      creds = {"uri": ENV['ETCD_URI']}
    else
      raise "$ETCD_BROKER_URI or $ETCD_URI required to configure etcd access"
    end
    self.create_cluster_etcd!(credentials: creds)
  end

  def broker_provision_etcd_creds
    binding = EtcdBrokerClient.new.provision_and_return_credentials(guid, guid)
    if binding
      binding_creds = binding["credentials"]
      {
        "uri": binding_creds["uri"],
        "host": binding_creds["host"],
        "port": binding_creds["port"],
        "username": binding_creds["username"],
        "password": binding_creds["password"],
        "keypath": binding_creds["keypath"],
      }
    else
      {}
    end
  end

  def cleanup_etcd!
    if ENV['ETCD_BROKER_URI']
      EtcdBrokerClient.new.cleanup!(guid, guid)
    elsif ENV['ETCD_URI']
      Rails.logger.info "TODO: implement Cluster#cleanup_etcd! for $ETCD_URI"
    end
  end
end
