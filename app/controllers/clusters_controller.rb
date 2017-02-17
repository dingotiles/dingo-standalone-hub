class ClustersController < ApplicationController
  def index
    if cluster = Cluster.last
      redirect_to cluster_path(cluster)
    else
      redirect_to tutorial_path
    end
  end

  def show
    @cluster = Cluster.find(params[:id])
  end
end
