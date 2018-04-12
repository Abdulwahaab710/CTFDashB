require 'test_helper'

class CtfSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ctf_settings_new_url
    assert_response :success
  end

  test "should get create" do
    get ctf_settings_create_url
    assert_response :success
  end

  test "should get edit" do
    get ctf_settings_edit_url
    assert_response :success
  end

  test "should get show" do
    get ctf_settings_show_url
    assert_response :success
  end

end
