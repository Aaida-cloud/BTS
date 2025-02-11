require "test_helper"

class Api::BugsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_bugs_index_url
    assert_response :success
  end
end
