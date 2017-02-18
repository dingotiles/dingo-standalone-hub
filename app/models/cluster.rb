class Cluster < ApplicationRecord
  belongs_to :account
  has_many :cluster_node_events

  after_create_commit { ClusterBroadcastJob.perform_later self }
end
