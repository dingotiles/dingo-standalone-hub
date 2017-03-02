require 'test_helper'

class WatcherControllerTest < ActionDispatch::IntegrationTest
  include ClimateOptionsHelper

  test "unknown cluster_id" do
    post "/watcher/clusters/UNKNOWN_CLUSTER/nodes/UNKNOWN", params: {}
    assert_response 404
    assert_equal JSON.parse(response.body)["error"], "unknown cluster_id 'UNKNOWN_CLUSTER'"
  end

  test "unknown node_id" do
    post "/watcher/clusters/cluster1/nodes/UNKNOWN", params: {}
    assert_response 404
    assert_equal JSON.parse(response.body)["error"], "unknown node_id 'UNKNOWN'"
  end

  test "update first node to running" do
    post "/watcher/clusters/cluster1/nodes/n1", params: {"state": "running"}
    assert_response 200
    assert_equal "running", cluster_nodes(:c1n1).state, "ClusterNode state"
    assert_equal "running", clusters(:cluster1).state, "Cluster state"
  end


  test "update only node to missing" do
    stub_request(:delete, "http://etcd.broker:6000/v2/service_instances/cluster1guid/service_bindings/cluster1guid").
      with(headers: {"Content-Type" => "application/json"}).
      to_return(status: 200)
    stub_request(:delete, "http://etcd.broker:6000/v2/service_instances/cluster1guid").
      with(headers: {"Content-Type" => "application/json"}).
      to_return(status: 200)
    assert_difference "ClusterEtcd.count", -1 do
      with_broker_etcd do
        post "/watcher/clusters/cluster1/nodes/n1", params: {"state": "missing"}
      end
    end
    assert_requested(:delete, "http://etcd.broker:6000/v2/service_instances/cluster1guid/service_bindings/cluster1guid", times: 1)
    assert_requested(:delete, "http://etcd.broker:6000/v2/service_instances/cluster1guid", times: 1)
    assert_response 200
    assert_equal "missing", cluster_nodes(:c1n1).state, "ClusterNode state"
    assert_equal "dead", clusters(:cluster1).state, "Cluster state"
  end
end
