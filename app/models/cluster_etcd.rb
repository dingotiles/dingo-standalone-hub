class ClusterEtcd < ApplicationRecord
  belongs_to :cluster

  def uri
    credentials["uri"]
  end
end
