require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_path
    assert_response :redirect
  end

end
