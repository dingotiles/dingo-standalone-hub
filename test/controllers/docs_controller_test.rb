require 'test_helper'

class DocsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get docs_index_url
    assert_response :success
  end

  test "should get tutorial" do
    get docs_tutorial_url
    assert_response :success
  end

end
