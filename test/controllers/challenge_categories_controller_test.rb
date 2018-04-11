require 'test_helper'

class ChallengeCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get challenge_categories_new_url
    assert_response :success
  end

  test "should get create" do
    get challenge_categories_create_url
    assert_response :success
  end

  test "should get edit" do
    get challenge_categories_edit_url
    assert_response :success
  end

end
