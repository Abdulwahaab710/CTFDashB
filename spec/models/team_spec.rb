# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  before(:each) do
    @team = Team.create!(name: 'DC613')
  end

  context 'when creating a team' do
    it 'is valid with valid attributes' do
      expect(@team).to eq(Team.first)
    end

    it 'enforces uniqueness of team name' do
      expect(Team.new(name: 'DC613').valid?).to be false
    end

    it 'has many users' do
      create_users
      expect(Team.last.users.count).to eq(2)
      expect(Team.last.users.first.username).to eq('007')
      expect(Team.last.users.last.username).to eq('008')
    end
  end

  context 'when calling #solved_challenges' do
    let(:team) { FactoryBot.create(:team) }
    let(:submission) { FactoryBot.create(:submission, valid_submission: true, flag: nil, team: team) }

    it 'returns a list of valid submissions' do
      expect(team.solved_challenges).to eq([submission])
    end
  end

  private

  def create_users
    @j007 = User.create!(
      name: 'James bond', email: 'James.bond@mi6.gov', username: '007',
      password: 'my amazing password', password_confirmation: 'my amazing password', team: @team
    )
    @j008 = User.create!(
      name: 'James bond', email: 'James.bond2@mi6.gov', username: '008',
      password: 'my amazing password', password_confirmation: 'my amazing password', team: @team
    )
  end
end
