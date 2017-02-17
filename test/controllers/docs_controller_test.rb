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

end
