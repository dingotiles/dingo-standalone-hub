class Cluster < ApplicationRecord
  belongs_to :account
  has_many :cluster_node_events, dependent: :destroy

  def self.dashboard
    order('updated_at DESC')
  end
end
