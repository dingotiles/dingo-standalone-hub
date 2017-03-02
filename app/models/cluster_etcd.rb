class ClusterEtcd < ApplicationRecord
  belongs_to :cluster
  before_destroy :cleanup_etcd

  def uri
    credentials["uri"]
  end

  def keypath
    credentials["keypath"]
  end

  private
  def cleanup_etcd
    if ENV['ETCD_BROKER_URI']
      EtcdBrokerClient.new.cleanup!(cluster.guid, cluster.guid)
    elsif ENV['ETCD_URI']
      Rails.logger.info "TODO: implement Cluster#cleanup_etcd! for $ETCD_URI"
    end
  end
end
