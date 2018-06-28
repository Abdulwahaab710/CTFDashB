# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session, type: :model do
  before(:each) do
    @user = User.create!(
      name: 'James bond',
      email: 'James.bond@mi6.gov',
      username: '007',
      password: 'my amazing password',
      password_confirmation: 'my amazing password'
    )

    @session = Session.create!(
      user: @user,
      ip_address: '127.0.0.1',
      browser: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3)'
    )
  end

  context 'when creating a new session' do
    it 'is valid with valid attributes' do
      expect(@session).to eq(Session.last)
    end

    it 'has a user' do
      expect(@user).to eq(Session.last.user)
    end

    it 'is not valid without a user' do
      expect(
        Session.new(
          ip_address: '127.0.0.1',
          browser: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3)'
        ).valid?
      ).to be false
    end
  end
end
