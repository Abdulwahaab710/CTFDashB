# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET new' do
    before(:each) do
      get :new
    end

    it 'renders the new template' do
      expect(response).to render_template('new')
    end

    it 'returns success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST create' do
    context 'when creating a valid user' do
      subject(:user) { post :create, params: user_params }

      setup do
        user
      end

      it 'redirects to the join team path' do
        expect(user).to have_http_status(:redirect)
        expect(user).to redirect_to join_team_path
      end

      it 'flashs with a success message' do
        expect(flash[:success]).to eq('Welcome to the CTFDashB, your account has been create')
      end
    end

    context 'when user params are missing' do
      subject(:user) { post :create, params: { user: {} } }

      setup do
        user
      end

      it 'returns a bad request status code' do
        expect(user).to have_http_status(:bad_request)
      end

      it 'flashs with an error message(s)' do
        expect(flash[:error]).to eq('Required parameters are missing.')
      end
    end
  end

  describe 'GET show' do
    context 'when the user exists' do
      before(:each) do
        user = FactoryBot.create(:user)
        FactoryBot.create(:session, user: user)
        login_as(user)
        get :show, params: { id: 'sherlock_holmes' }
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the show view' do
        expect(response).to render_template('show')
      end
    end

    context 'when the user does not exist' do
      before(:each) do
        get :show, params: { id: 'sherlock_holmes' }
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET edit' do
    context 'when the user is logged in' do
    end

    context 'when the user is not logged in' do
    end
  end

  describe 'PATCH edit' do
    context 'when the user is logged in' do
    end

    context 'when the user is not logged in' do
    end
  end

  describe 'GET settings' do
    context 'when the user is logged in' do
    end

    context 'when the user is  not logged in' do
    end
  end

  private

  def user_params
    {
      user: {
        name: 'James Bond',
        email: 'james.bond@mi6.com',
        username: '007',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end
end
