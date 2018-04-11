require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: {
          name:  '',
          username: 'someusername',
          email: 'user@invalid',
          password:              'foo',
          password_confirmation: 'bar'
        }
      }
    end
    assert_template 'users/new'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {
        user: {
          name:  'Example User',
          username: 'username_example',
          email: 'user@example.com',
          password:              'password',
          password_confirmation: 'password'
        }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_equal flash[:success], 'Welcome to the CTFDashB'
  end
end
