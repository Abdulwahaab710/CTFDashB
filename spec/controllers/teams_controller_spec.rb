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

      # it 'redirect to the team' do
      #   expect(response).to redirect_to(team_path(enrolled_user.team))
      # end
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

  #   describe 'POST join_team' do
  #     context 'when the user is not enrolled in a team' do
  #       before :each do
  #         FactoryBot.create(:session, user: user)
  #         login_as(user)

  #         get :new
  #       end

  #       it 'renders new' do
  #         expect(response).to have_rendered('new')
  #       end

  #       it 'is successful' do
  #         expect(response).to be_successful
  #       end
  #     end

  #     context 'when the user is not enrolled in a team' do
  #       before :each do
  #         FactoryBot.create(:session, user: enrolled_user)
  #         login_as(enrolled_user)

  #         get :new
  #       end

  #       it 'returns 302' do
  #         expect(response).to have_http_status(:redirect)
  #       end

  #       it 'redirect to the team' do
  #         expect(response).to redirect_to(team_path(enrolled_user.team))
  #       end
  #     end
  #   end

  #   describe 'DELETE withdraw' do
  #     context 'when the user is not enrolled in a team' do
  #       before :each do
  #         FactoryBot.create(:session, user: user)
  #         login_as(user)

  #         get :new
  #       end

  #       it 'renders new' do
  #         expect(response).to have_rendered('new')
  #       end

  #       it 'is successful' do
  #         expect(response).to be_successful
  #       end
  #     end

  #     context 'when the user is not enrolled in a team' do
  #       before :each do
  #         FactoryBot.create(:session, user: enrolled_user)
  #         login_as(enrolled_user)

  #         get :new
  #       end

  #       it 'returns 302' do
  #         expect(response).to have_http_status(:redirect)
  #       end

  #       it 'redirect to the team' do
  #         expect(response).to redirect_to(team_path(enrolled_user.team))
  #       end
  #     end
  #   end

  private

  def user
    @user ||= FactoryBot.create(:user, team: nil)
  end

  def enrolled_user
    @enrolled_user ||= FactoryBot.create(:user)
  end
end
