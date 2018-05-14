# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  before(:each) do
    @user = User.create!(
      name: 'James bond',
      email: 'James.bond@mi6.gov',
      username: '007',
      password: 'my amazing password'
    )
    @team = Team.create!(name: 'DC6113')
    @tm = TeamMember.create!(user: @user, team: @team)
  end

  context 'when adding a user to a team' do
    it 'is valid with valid attributes' do
      expect(TeamMember.first.team).to eq(@team)
      expect(TeamMember.first.user).to eq(@user)
    end
  end
end
