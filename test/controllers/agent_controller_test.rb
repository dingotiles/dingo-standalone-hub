require 'test_helper'

# TODO: tests using global env vars, and assume S3 is configured with them
class AgentControllerTest < ActionDispatch::IntegrationTest
  include ClimateOptionsHelper

  def metadata
    {
      "agent_version": "dev",
      "image_version": "0.0.8",
      "image_name": "dingotiles/dingo-postgresql",
    }
  end

  test "POST collects image/agent metadata" do
    assert_difference "ClusterNode.count", 1 do
      with_global do
        post "/agent/api", params: {
          "cluster": "new1",
          "node": "n1",
          "account": "newacct@example.com",
        }.merge(metadata)
        assert_response :success
      end
    end
    cluster_node = ClusterNode.last
    assert_equal "dev", cluster_node.agent_version
    assert_equal "0.0.8", cluster_node.image_version
    assert_equal "dingotiles/dingo-postgresql", cluster_node.image_name
  end

  test "POST assigns global s3 archive" do
    with_global_archive_s3 do
      post "/agent/api", params: {
        "cluster": "new1",
        "node": "n1",
        "account": "newacct@example.com",
      }.merge(metadata)
      assert_response :success
      resp = JSON.parse(response.body)
      assert "s3", resp["archives"]["method"]
      s3 = resp["archives"]["s3"]
      assert s3
      assert_equal "key", s3["aws_access_key_id"]
      assert_equal "secret", s3["aws_secret_access_id"]
      assert_equal "bucket", s3["s3_bucket"]
      assert_equal "endpoint", s3["s3_endpoint"]
    end
  end

  test "POST assigns global ssh archive" do
    with_global_archive_ssh do
      post "/agent/api", params: {
        "cluster": "new1",
        "node": "n1",
        "account": "newacct@example.com",
      }.merge(metadata)
      assert_response :success
      resp = JSON.parse(response.body)
      assert_equal "ssh", resp["archives"]["method"]
      ssh = resp["archives"]["ssh"]
      assert ssh
      assert_equal "localhost", ssh["host"]
      assert_equal "22", ssh["port"]
      assert_equal "dingo", ssh["user"]
      assert_equal "inline-key", ssh["private_key"]
      assert_equal "/data/", ssh["base_path"]
    end
  end

  test "POST provision broker s3 archive" do
    with_broker_archive_s3 do
      post "/agent/api", params: {
        "cluster": "new1",
        "node": "n1",
        "account": "newacct@example.com",
      }.merge(metadata)
      assert_response :success
      resp = JSON.parse(response.body)
      assert "s3", resp["archives"]["method"]
      s3 = resp["archives"]["s3"]
      assert s3
      assert_equal "broker-key", s3["aws_access_key_id"]
      assert_equal "broker-secret", s3["aws_secret_access_id"]
      assert_equal "dingo-hub-s3-testing-test1", s3["s3_bucket"]
      assert_equal "https+path://s3-us-east-2.amazonaws.com:443", s3["s3_endpoint"]
    end
  end

  test "POST assigns global etcd" do
    assert_difference "ClusterEtcd.count", +1 do
      with_global_etcd do
        post "/agent/api", params: {
          "cluster": "new1",
          "node": "n1",
          "account": "newacct@example.com",
        }.merge(metadata)
        assert_response :success
        resp = JSON.parse(response.body)
        assert_equal "http://global.shared.db:4001", resp["etcd"]["uri"]
      end
    end
  end

  test "POST assigns brokered etcd" do
    assert_difference "ClusterEtcd.count", +1 do
      with_broker_etcd do
        post "/agent/api", params: {
          "cluster": "new1",
          "node": "n1",
          "account": "newacct@example.com",
        }.merge(metadata)
        assert_response :success
        resp = JSON.parse(response.body)
        assert_equal "http://user-abcdef:password@etcd.cluster:4001", resp["etcd"]["uri"]
      end
    end
  end

  test "should POST new cluster node" do
    assert_difference "Account.count", +1 do
      assert_difference "Cluster.count", +1 do
        assert_difference "ClusterNode.count", +1 do
          with_global do
            post "/agent/api", params: {
              "cluster": "new1",
              "node": "n1",
              "account": "newacct@example.com",
            }.merge(metadata)
          end
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], "new1"
    assert resp["cluster"]["name"], "n1"
  end

  test "should POST new cluster node to existing account" do
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", +1 do
        assert_difference "ClusterNode.count", +1 do
          with_global do
            post "/agent/api", params: {
              "cluster": "new1",
              "node": "n1",
              "account": accounts(:known).email,
            }.merge(metadata)
          end
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], "new1"
    assert resp["cluster"]["name"], "n1"
  end

  test "should POST new cluster node to known cluster" do
    cluster = clusters(:cluster1)
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", 0 do
        assert_difference "ClusterNode.count", +1 do
          assert_difference "ClusterEtcd.count", 0 do
            with_global do
              post "/agent/api", params: {
                "cluster": cluster.name,
                "node": "newnode1",
                "account": cluster.account.email,
              }.merge(metadata)
            end
          end
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], clusters(:cluster1).name
    assert resp["cluster"]["name"], "newnode1"
  end

  test "should POST re-launch of previous cluster node" do
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", 0 do
        assert_difference "ClusterNode.count", 0 do
          assert_difference "ClusterEtcd.count", 1 do
            with_global do
              post "/agent/api", params: {
                "cluster": clusters(:cluster_dead).name,
                "node": cluster_nodes(:cluster_dead_n1).name,
                "account": clusters(:cluster_dead).account.email,
              }.merge(metadata)
            end
          end
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], clusters(:cluster_dead).name
    assert resp["cluster"]["name"], cluster_nodes(:cluster_dead_n1).name
  end
end
