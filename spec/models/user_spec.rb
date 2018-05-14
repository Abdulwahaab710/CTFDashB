# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.create!(
      name: 'James bond',
      email: 'James.bond@mi6.gov',
      username: '007',
      password: 'my amazing password'
    )
  end

  context 'when creating a user' do
    it 'is valid with valid attributes' do
      expect(@user).to eq(User.last)
    end

    it 'enforces uniqueness of users username' do
      expect(
        User.new(
          name: 'James bond',
          email: 'James.bond2@mi6.gov',
          username: '007',
          password: 'my amazing password'
        ).valid?
      ).to eq false
    end

    it 'enforces uniqueness of users email' do
      expect(
        User.new(
          name: 'James bond',
          email: 'James.bond@mi6.gov',
          username: '008',
          password: 'my amazing password'
        ).valid?
      ).to eq false
    end
  end
end
