require 'test_helper'

class WatcherControllerTest < ActionDispatch::IntegrationTest
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

  test "update node to running" do
    post "/watcher/clusters/cluster1/nodes/n1", params: {"state": "running"}
    assert_response 200
    assert_equal "running", cluster_nodes(:c1n1).state, "ClusterNode state"
    assert_equal "running", clusters(:cluster1).state, "Cluster state"
  end
end
