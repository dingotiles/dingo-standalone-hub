class ClusterBroadcastJob < ApplicationJob
  queue_as :default

  def perform(cluster)
    ActionCable.server.broadcast 'cluster_channel', cluster: cluster.name
  end
end
