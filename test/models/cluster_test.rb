require 'test_helper'

class ClusterTest < ActiveSupport::TestCase
  include ClimateOptionsHelper

  test "deletes dependents" do
    stub_request(:delete, "http://etcd.broker:6000/v2/service_instances/cluster1guid/service_bindings/cluster1guid").
      with(headers: {"Content-Type" => "application/json"}).
      to_return(status: 200)
    stub_request(:delete, "http://etcd.broker:6000/v2/service_instances/cluster1guid").
      with(headers: {"Content-Type" => "application/json"}).
      to_return(status: 200)
    assert_difference "Cluster.count", -1 do
      assert_difference "ClusterNode.count", -1 do
        with_broker_etcd do
          clusters(:cluster1).destroy!
        end
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
    assert_equal "/service/", @cluster.etcd_namespace
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
    assert_equal "/service_instances/qwerty/service/", @cluster.etcd_namespace
  end
end
