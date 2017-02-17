class Cluster < ApplicationRecord
  belongs_to :account
  has_many :cluster_nodes
end
