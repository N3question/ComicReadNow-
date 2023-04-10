require "test_helper"

class Public::UserRankingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_user_rankings_index_url
    assert_response :success
  end
end
