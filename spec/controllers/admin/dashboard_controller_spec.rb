# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  describe 'GET index' do
    context 'when the user has challenges' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        @challenge = FactoryBot.create(:challenge, user: organizer)
        FactoryBot.create(:team)
        FactoryBot.create(:submission, challenge: @challenge, category: @challenge.category)
        get :index
      end

      it 'returns success' do
        expect(response).to be_successful
      end

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'list all the challenges owned by the current_user' do
        expect(assigns[:user_challenges]).to eq(
          organizer&.challenges&.includes(:submissions)&.group_by { |c| c.category }
        )
        expect(assigns[:total_teams]).to eq(Team.count)
      end
    end
  end

  private

  def user
    @user ||= FactoryBot.create(:user)
  end

  def organizer
    @organizer ||= FactoryBot.create(:user, organizer: true)
  end
end
