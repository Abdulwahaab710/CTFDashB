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
    @admin = User.create!(
      name: 'James bond boss',
      email: 'theJames.bond.boss@mi6.gov',
      username: '001',
      password: 'my amazing password',
      admin: true,
      organizer: true
    )
  end

  context 'when creating a user' do
    it 'is valid with valid attributes' do
      expect(@user).to eq(User.first)
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

    it 'returns false if the user is not admin' do
      expect(@user.admin?).to eq(false)
    end

    it 'returns true if the user is admin' do
      expect(@admin.admin?).to eq(true)
    end

    it 'returns false if the user is not organizer' do
      expect(@user.organizer?).to eq(false)
    end

    it 'returns true if the user is organizer' do
      expect(@admin.organizer?).to eq(true)
    end
  end
end
