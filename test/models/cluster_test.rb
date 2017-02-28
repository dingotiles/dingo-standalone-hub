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

  test "with shared etcd on create allocates etcd credentials" do
    assert_difference "ClusterEtcd.count", +1 do
      with_global_etcd do
        @cluster = accounts(:known).clusters.create
      end
    end
    etcd = @cluster.cluster_etcd
    assert_equal "http://global.shared.db:4001", etcd.credentials["uri"]
    assert_equal "http://global.shared.db:4001", etcd.uri
  end

  test "with broker etcd on create allocates unique credentials" do
    assert_difference "ClusterEtcd.count", +1 do
      with_broker_etcd do
        @cluster = accounts(:known).clusters.create
      end
    end
    etcd = @cluster.cluster_etcd
    assert_equal "http://user-abcdef:password@etcd.cluster:4001", etcd.credentials["uri"]
    assert_equal "http://etcd.cluster:4001", etcd.credentials["host"]
    assert_equal "/service_instances/qwerty", etcd.credentials["keypath"]
    assert_equal "http://user-abcdef:password@etcd.cluster:4001", etcd.uri
  end
end
