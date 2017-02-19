class ClusterBroadcastJob < ApplicationJob
  queue_as :default

  def perform(cluster)
    ActionCable.server.broadcast 'cluster_channel', clusters: render_clusters(Cluster.dashboard)
  end

  private
  def render_clusters(clusters)
    ApplicationController.renderer.render(partial: "clusters/clusters", locals: {clusters: clusters})
  end
end
