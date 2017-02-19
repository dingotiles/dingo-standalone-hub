require 'test_helper'

class AgentControllerTest < ActionDispatch::IntegrationTest
  test "should POST new cluster node" do
    assert_difference "Account.count", +1 do
      assert_difference "Cluster.count", +1 do
        assert_difference "ClusterNode.count", +1 do
          post "/agent/api", params: {
            "cluster": "new1",
            "node": "n1",
            "account": "newacct@example.com",
            "image_version": "0.0.8",
          }
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], "new1"
    assert resp["cluster"]["name"], "n1"
  end

  test "should POST new cluster node to existing account" do
    Account.create(email: "known-account@example.com")
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", +1 do
        assert_difference "ClusterNode.count", +1 do
          post "/agent/api", params: {
            "cluster": "new1",
            "node": "n1",
            "account": "known-account@example.com",
            "image_version": "0.0.8",
          }
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], "new1"
    assert resp["cluster"]["name"], "n1"
  end

  test "should POST new cluster node to known cluster" do
    Account.create(email: "known-account@example.com")
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", 0 do
        assert_difference "ClusterNode.count", +1 do
          post "/agent/api", params: {
            "cluster": clusters(:cluster1).name,
            "node": "newnode1",
            "account": "known-account@example.com",
            "image_version": "0.0.8",
          }
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], clusters(:cluster1).name
    assert resp["cluster"]["name"], "newnode1"
  end

  test "should POST re-launch of known cluster node" do
    Account.create(email: "known-account@example.com")
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", 0 do
        assert_difference "ClusterNode.count", 0 do
          post "/agent/api", params: {
            "cluster": clusters(:cluster1).name,
            "node": cluster_nodes(:c1n1).name,
            "account": "known-account@example.com",
            "image_version": "0.0.8",
          }
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], clusters(:cluster1).name
    assert resp["cluster"]["name"], cluster_nodes(:c1n1).name
  end
end
