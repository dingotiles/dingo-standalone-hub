require 'test_helper'

# TODO: tests using global env vars, and assume S3 is configured with them
class AgentControllerTest < ActionDispatch::IntegrationTest
  def global_s3_options
    {
      "AWS_ACCESS_KEY_ID": "key",
      "AWS_SECRET_ACCESS_KEY": "secret",
      "WAL_S3_BUCKET": "bucket",
      "WALE_S3_ENDPOINT": "endpoint",
    }
  end

  def global_etcd_options
    {
      "ETCD_URI": "http://localhost:4001",
    }
  end

  def with_global_archive_s3(&block)
    options = global_s3_options.merge(global_etcd_options)
    ClimateControl.modify(options, &block)
  end

  def with_global_etcd(&block)
    options = global_etcd_options.merge(global_s3_options)
    ClimateControl.modify(options, &block)
  end

  def with_global(&block)
    options = global_etcd_options.merge(global_s3_options)
    ClimateControl.modify(options, &block)
  end

  test "POST assigns s3 archive" do
    with_global_archive_s3 do
      post "/agent/api", params: {
        "cluster": "new1",
        "node": "n1",
        "account": "newacct@example.com",
        "image_version": "0.0.8",
      }
      assert_response :success
      resp = JSON.parse(response.body)
      assert "s3", resp["archives"]["method"]
      s3 = resp["archives"]["s3"]
      assert_equal "key", s3["aws_access_key_id"]
      assert_equal "secret", s3["aws_secret_access_id"]
      assert_equal "bucket", s3["s3_bucket"]
      assert_equal "endpoint", s3["s3_endpoint"]
    end
  end

  test "POST assigns etcd" do
    with_global_etcd do
      post "/agent/api", params: {
        "cluster": "new1",
        "node": "n1",
        "account": "newacct@example.com",
        "image_version": "0.0.8",
      }
      assert_response :success
      resp = JSON.parse(response.body)
      assert_equal "http://localhost:4001", resp["etcd"]["uri"]
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
              "image_version": "0.0.8",
            }
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
    Account.create(email: "known-account@example.com")
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", +1 do
        assert_difference "ClusterNode.count", +1 do
          with_global do
            post "/agent/api", params: {
              "cluster": "new1",
              "node": "n1",
              "account": "known-account@example.com",
              "image_version": "0.0.8",
            }
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
          with_global do
            post "/agent/api", params: {
              "cluster": cluster.name,
              "node": "newnode1",
              "account": cluster.account.email,
              "image_version": "0.0.8",
            }
          end
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], clusters(:cluster1).name
    assert resp["cluster"]["name"], "newnode1"
  end

  test "should POST re-launch of known cluster node" do
    cluster = clusters(:cluster1)
    assert_difference "Account.count", 0 do
      assert_difference "Cluster.count", 0 do
        assert_difference "ClusterNode.count", 0 do
          with_global do
            post "/agent/api", params: {
              "cluster": cluster.name,
              "node": cluster_nodes(:c1n1).name,
              "account": cluster.account.email,
              "image_version": "0.0.8",
            }
          end
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["scope"], clusters(:cluster1).name
    assert resp["cluster"]["name"], cluster_nodes(:c1n1).name
  end
end
