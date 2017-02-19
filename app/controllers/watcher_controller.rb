class WatcherController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    Rails.logger.info "update #{params.inspect}"
    unless cluster = Cluster.find_by(name: params[:cluster_id])
      render status: 404, json: {error: "unknown cluster_id '#{params[:cluster_id]}'"}
      return
    end
    unless node = cluster.cluster_nodes.find_by(name: params[:node_id])
      render status: 404, json: {error: "unknown node_id '#{params[:node_id]}'"}
      return
    end
    ActiveRecord::Base.transaction do
      node.state = params["state"]
      node.role = params["role"]
      # NOTE: currently working on 1-node clusters; there for cluster has node's state
      node.save!
      cluster.update_state_from_nodes!
    end
    render json: {}, status: :ok
  end
end
