class ClustersController < ApplicationController
  def self.limit_node_events
    3
  end

  def index
    @clusters = Cluster.order('updated_at DESC')
  end

  def show
    @cluster = Cluster.find(params[:id])
  end
end
