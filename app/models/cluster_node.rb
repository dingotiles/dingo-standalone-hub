class ClusterNode < ApplicationRecord
  belongs_to :cluster, touch: true

  after_create_commit { ClusterBroadcastJob.perform_later self }

  def running?
    state == "running"
  end
end
