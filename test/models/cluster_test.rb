require 'test_helper'

class ClusterTest < ActiveSupport::TestCase
  include ClimateOptionsHelper

  test "deletes dependents" do
    assert_difference "Cluster.count", -1 do
      assert_difference "ClusterNode.count", -1 do
        clusters(:cluster1).destroy!
      end
    end
  end

  test "on create allocates etcd credentials" do
    assert_difference "ClusterEtcd.count", +1 do
      with_global do
        @cluster = accounts(:known).clusters.create
      end
    end
    etcd = @cluster.cluster_etcd
    assert_equal "http://global.shared.db:4001", etcd.credentials["uri"]
    assert_equal "http://global.shared.db:4001", etcd.uri
  end
end
