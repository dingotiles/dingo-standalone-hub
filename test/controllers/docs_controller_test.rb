require 'test_helper'

class DocsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/"
    assert_response :success
  end

  test "should get tutorial" do
    get "/tutorial"
    assert_response :success
  end

  test "should POST new cluster node" do
    assert_difference "Account.count", +1 do
      assert_difference "Cluster.count", +1 do
        assert_difference "ClusterNode.count", +1 do
          post "/agent/api", params: {"cluster": "c1", "node": "n1", "account": "newacct@example.com"}
        end
      end
    end
    assert_response :success
    resp = JSON.parse(response.body)
    assert resp["cluster"]["name"], "n1"
    assert resp["cluster"]["scope"], "c1"
  end
end
