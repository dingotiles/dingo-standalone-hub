class ClustersController < ApplicationController
  def index
    @clusters = Cluster.order('updated_at DESC')
  end

  def show
    @cluster = Cluster.find(params[:id])
  end
end
