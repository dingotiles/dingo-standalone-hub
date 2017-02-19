class Cluster < ApplicationRecord
  belongs_to :account
  has_many :cluster_nodes, dependent: :destroy

  after_commit on: [:update, :destroy] { ClusterBroadcastJob.perform_later self }

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
end
