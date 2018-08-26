# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe 'GET new' do
    context 'when the user is not enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)

        get :new
      end

      it 'renders new' do
        expect(response).to have_rendered('new')
      end

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'when the user is enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: enrolled_user)
        login_as(enrolled_user)

        get :new
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirect to the team' do
        expect(response).to redirect_to(team_path(enrolled_user.team))
      end
    end
  end

  describe 'POST create' do
    context 'when the user is not enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)

        post :create, params: { team: { name: 'CTFDashB_TEAM' } }
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirect to the team' do
        expect(response).to redirect_to(team_path(Team.last))
      end
    end

    context 'when the user is enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: enrolled_user)
        login_as(enrolled_user)

        post :create, params: { team: { name: 'Fake team' } }
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET show' do
    context 'when the user is enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: enrolled_user)
        login_as(enrolled_user)

        get :show, params: { id: enrolled_user.team }
      end

      it 'renders show' do
        expect(response).to have_rendered('show')
      end

      it 'is successful' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET join' do
    context 'when the user is not enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)

        get :join
      end

      it 'renders join' do
        expect(response).to have_rendered('join')
      end

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'when the user is not enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: enrolled_user)
        login_as(enrolled_user)

        get :join
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirect to the team' do
        expect(response).to redirect_to(team_path(enrolled_user.team))
      end
    end
  end

  describe 'POST join_team' do
    before do
      FactoryBot.create(:team_size)
    end

    context 'when the invitation_token is invalid' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)

        post :join_team, params: { team: { invitation_token: 'invalid token' } }
      end

      it 'redirects back to the join page' do
        expect(response).to redirect_to(join_team_path)
      end

      it 'returns a flash with Invalid token' do
        expect(flash[:danger]).to eq('Invalid token')
      end
    end

    context 'when the invitation_token is valid' do
      before :each do
        FactoryBot.create(:session, user: user)
        @team = FactoryBot.create(:team)

        login_as(user)

        post :join_team, params: { team: { invitation_token: Team.last.invitation_token } }
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirect to the team' do
        expect(response).to redirect_to(team_path(@team))
      end

      it 'adds the user to the team' do
        expect(Team.last.users.last).to eq(user)
      end
    end

    context 'when the invitation_token is valid and the team is full' do
      let (:team) { FactoryBot.create(:team) }
      before :each do
        FactoryBot.create(:session, user: user)
        4.times do
          FactoryBot.create(:user, team: team)
        end

        login_as(user)

        post :join_team, params: { team: { invitation_token: Team.last.invitation_token } }
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirect to join team' do
        expect(response).to redirect_to(join_team_path)
      end

      it 'flashes with an error that the team is full' do
        expect(flash[:danger]).to eq("Team #{team.name} is already full")
      end
    end
  end

  describe 'DELETE withdraw' do
    context 'when the user is enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: enrolled_user)
        login_as(enrolled_user)

        delete :withdraw
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirect to join team' do
        expect(response).to redirect_to(join_team_path)
      end
    end

    context 'when the user is not enrolled in a team' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)

        delete :withdraw
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  private

  def user
    @user ||= FactoryBot.create(:user, team: nil)
  end

  def enrolled_user
    @enrolled_user ||= FactoryBot.create(:user)
  end
end
