require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Example User',
      email: 'user@example.com',
      username: 'username',
      password: 'foobar',
      password_confirmation: 'foobar'
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'username should be present' do
    @user.username = ''
    assert_not @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'password should be present' do
    @user.password = nil
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 254
    assert @user.valid?
    @user.name = 'a' * 256
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 220 + '@example.com'
    assert @user.valid?

    @user.email = 'a' * 256 + '@example.com'
    assert_not @user.valid?
  end

  test 'username should not be too long' do
    @user.username = 'a' * 254
    assert @user.valid?

    @user.username = 'a' * 256
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w( user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn )
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w( user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com )
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses and usernames should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    duplicate_user.username = @user.username.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end
