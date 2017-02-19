class ClusterNodeEvent < ApplicationRecord
  belongs_to :cluster, touch: true

  after_create_commit { ClusterBroadcastJob.perform_later self }
end
