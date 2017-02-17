class ClustersController < ApplicationController
  def index
    @clusters = Cluster.all
  end

  def show
    @cluster = Cluster.find(params[:id])
  end
end
