class ClusterNodeEvent < ApplicationRecord
  belongs_to :cluster, touch: true
end
