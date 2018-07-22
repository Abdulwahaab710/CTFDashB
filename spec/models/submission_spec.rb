# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission, type: :model do
  before :each do
    @user = FactoryBot.create(:user)
    @challenge = FactoryBot.create(:challenge)
  end

  context 'when creating a submission' do
    it 'is valid with valid attributes' do
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          team: @user.team,
          user: @user,
          submission_hash: 'somehash',
          valid_submission: true,
          category: @challenge.category,
          challenge: @challenge
        )
      ).to be_valid
    end

    it 'enforces uniqueness for submission_hash' do
      Submission.create(
        flag: 'flag{someflag}',
        team: @user.team,
        user: @user,
        submission_hash: 'somehash',
        valid_submission: true,
        category: @challenge.category,
        challenge: @challenge
      )
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          team: @user.team,
          user: @user,
          submission_hash: 'somehash',
          valid_submission: true,
          category: @challenge.category,
          challenge: @challenge
        )
      ).to_not be_valid
    end

    it 'is invalid without a user' do
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          team: @user.team,
          submission_hash: 'somehash',
          valid_submission: true,
          category: @challenge.category,
          challenge: @challenge
        )
      ).to_not be_valid
    end

    it 'is invalid without a team' do
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          user: @user,
          submission_hash: 'somehash',
          valid_submission: true,
          category: @challenge.category,
          challenge: @challenge
        )
      ).to_not be_valid
    end

    it 'is invalid without a valid_submission boolean' do
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          team: @user.team,
          user: @user,
          submission_hash: 'somehash',
          category: @challenge.category,
          challenge: @challenge
        )
      ).to_not be_valid
    end

    it 'is invalid without a challenge' do
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          team: @user.team,
          user: @user,
          submission_hash: 'somehash',
          valid_submission: true,
          category: @challenge.category
        )
      ).to_not be_valid
    end

    it 'is invalid without a category' do
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          team: @user.team,
          user: @user,
          submission_hash: 'somehash',
          valid_submission: true,
          challenge: @challenge
        )
      ).to_not be_valid
    end

    it 'is invalid without a submission_hash' do
      expect(
        Submission.new(
          flag: 'flag{someflag}',
          team: @user.team,
          user: @user,
          valid_submission: true,
          category: @challenge.category,
          challenge: @challenge
        )
      ).to_not be_valid
    end
  end
end
