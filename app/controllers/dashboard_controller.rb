class DashboardController < ApplicationController
  def index
    redirect_to clusters_path
  end
end
