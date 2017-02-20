require 'test_helper'

class ClusterTest < ActiveSupport::TestCase
  test "deletes dependents" do
    assert_difference "Cluster.count", -1 do
      assert_difference "ClusterNode.count", -1 do
        clusters(:cluster1).destroy!
      end
    end
  end

  test "on create allocates etcd credentials" do
    assert_difference "ClusterEtcd.count", +1 do
      @cluster = accounts(:known).clusters.create
    end
    etcd = @cluster.cluster_etcd
    assert etcd.credentials["uri"]
    assert etcd.uri
  end
end
