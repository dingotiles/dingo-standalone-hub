class ClusterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "cluster_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def provision
    Rails.logger.info "Inbound #provision request"
    ActionCable.server.broadcast 'cluster_channel', cluster: "Hi there"
  end
end
