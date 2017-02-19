class ClustersController < ApplicationController
  def self.limit_node_events
    3
  end

  def index
    @clusters = Cluster.dashboard
  end

  def show
    @cluster = Cluster.dashboard.find(params[:id])
  end
end
