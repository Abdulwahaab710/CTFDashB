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
  end
end
