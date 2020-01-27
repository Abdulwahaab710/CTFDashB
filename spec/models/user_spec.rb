# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.create!(
      name: 'James bond',
      email: 'James.bond@mi6.gov',
      username: '007',
      password: 'my amazing password',
      password_confirmation: 'my amazing password'
    )
    @admin = User.create!(
      name: 'James bond boss',
      email: 'theJames.bond.boss@mi6.gov',
      username: '001',
      password: 'my amazing password',
      password_confirmation: 'my amazing password',
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
          password: 'my amazing password',
          password_confirmation: 'my amazing password'
        ).valid?
      ).to eq false
    end

    it 'enforces the presences of users password' do
      expect(
        User.new(
          name: 'James bond',
          email: 'James.bond2@mi6.gov',
          username: '008'
        ).valid?
      ).to eq false
    end

    it 'enforces the presences of users password_confirmation' do
      expect(
        User.new(
          name: 'James bond',
          email: 'James.bond2@mi6.gov',
          username: '008',
          password: 'my amazing password'
        ).valid?
      ).to eq false
      expect(
        User.new(
          name: 'James bond',
          email: 'James.bond2@mi6.gov',
          username: '008',
          password: 'my amazing password',
          password_confirmation: 'my amazing password'
        ).valid?
      ).to eq true
    end

    it 'enforces uniqueness of users email' do
      expect(
        User.new(
          name: 'James bond',
          email: 'James.bond@mi6.gov',
          username: '008',
          password: 'my amazing password',
          password_confirmation: 'my amazing password'
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

  context 'when calling valid_submissions' do
    before :each do
      @user = FactoryBot.create(:user)
      @submission = FactoryBot.create(:submission, user: @user, team: @user.team, valid_submission: true)
      FactoryBot.create(
        :submission,
        user: @user,
        team: @user.team,
        valid_submission: false,
        challenge: @submission.challenge,
        category: @submission.category
      )
    end

    it 'returns all valid submissions for a user' do
      expect(@user.valid_submissions).to eq([@submission])
    end
  end
end
