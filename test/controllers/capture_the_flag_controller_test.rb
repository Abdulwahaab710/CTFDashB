require 'test_helper'

class CaptureTheFlagControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get capture_the_flag_new_url
    assert_response :success
  end

  test "should get create" do
    get capture_the_flag_create_url
    assert_response :success
  end

end
