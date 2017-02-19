require 'test_helper'

class ClusterTest < ActiveSupport::TestCase
  test "deletes dependents" do
    assert_difference "Cluster.count", -1 do
      assert_difference "ClusterNodeEvent.count", -2 do
        clusters(:cluster1).destroy!
      end
    end
  end
end
