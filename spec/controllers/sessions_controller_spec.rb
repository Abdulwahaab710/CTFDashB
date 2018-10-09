# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET new' do
    context 'when the user is already logged in' do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        get :new
      end

      it 'redirects to cuurent_user' do
        expect(response).to redirect_to(user_path(user))
      end
      it 'returns a HTTP status redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when the user is not logged in' do
      before :each do
        get :new
      end

      it 'renders to them the new template' do
        expect(response).to render_template('new')
      end

      it 'returns 200 status code' do
        expect(response).to have_http_status(:successful)
      end
    end
  end

  describe 'POST create' do
    context 'when a user tries to login using a valid email and password' do
      subject(:user_login) { post :create, params: user_session_params(email: user.email) }

      let(:user) { FactoryBot.create(:user) }

      setup do
        @user = FactoryBot.create(:user)
        user_login
      end

      it 'creates a session for them' do
        expect(User.last.sessions.count).to eq(1)
      end

      it 'returns redirect' do
        expect(user_login).to have_http_status(:redirect)
      end

      it 'redirects to the users profile' do
        expect(user_login).to redirect_to user_path(user)
      end
    end

    context 'when a user tries to login using a username and password' do
      subject(:user_login) { post :create, params: user_session_params(email: user.username) }

      let(:user) { FactoryBot.create(:user) }

      setup do
        user_login
      end

      it 'creates a session for them' do
        expect(User.last.sessions.count).to eq(1)
      end

      it 'returns redirect' do
        expect(user_login).to have_http_status(:redirect)
      end

      it 'redirects to the users profile' do
        expect(user_login).to redirect_to user_path(user)
      end
    end

    context 'when the users account is deactivated/disabled' do
      subject(:user_login) { post :create, params: user_session_params(email: user.username) }

      let(:user) { FactoryBot.create(:user, active: false) }

      setup do
        user_login
      end

      it 'flashes with You account is disabled' do
        expect(flash[:danger]).to eq('Your account is disabled')
      end

      it 'returns a status code forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when a user tries to login using a invalid email or password' do
      subject(:user_login) { post :create, params: user_session_params(password: '123') }

      setup do
        @user = FactoryBot.create(:user)
        user_login
      end

      it 'creates a session for them' do
        expect(user_login).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when the user is logged in' do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        delete :destroy
      end

      it 'deletes the users session' do
        expect(Session.count).to eq(0)
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'remove the session id' do
        expect(session[:user_session_id]).to eq(nil)
      end
    end

    context 'when the user is not logged in' do
      before :each do
        delete :destroy
      end

      it 'returns 302' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to login page' do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'GET users_sessions' do
    context 'when the user is logged in' do
      let(:user) { FactoryBot.create(:user) }

      before(:each) do
        @session = FactoryBot.create(:session, user: user)
        login_as(user)
        get :users_sessions
      end

      it 'returns http status code 200' do
        expect(response).to have_http_status(:successful)
      end

      it 'returns users all sessions' do
        expect(assigns(:sessions).first[:id]).to eq(@session.id)
      end
    end

    context 'when the user is not logged in' do
      before :each do
        get :users_sessions
      end

      it 'redirects to login page' do
        expect(response).to redirect_to(login_path)
      end

      it 'returns 302 HTTP status code' do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'DELETE destroy_session' do
    context 'when the user is logged in' do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        @session = FactoryBot.create(:session, user: user)
        2.times do
          FactoryBot.create(:session, user: user)
        end
        login_as(user)
        get :users_sessions
      end

      it 'deletes the users session' do
        expect { delete :destroy_session, params: { id: @session.id } }.to change { Session.count }.from(3).to(2)
      end

      it 'returns 404 if the session id does not exists' do
        delete :destroy_session, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the user is not logged in' do
      before :each do
        delete :destroy_session, params: { id: 1 }
      end

      it 'redirects to login page' do
        expect(response).to redirect_to(login_path)
      end

      it 'returns 302 HTTP status code' do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  private

  def user_session_params(email: 'sherlock_holmes@21baker.street', password: 'sher123')
    {
      session: {
        email: email,
        password: password
      }
    }
  end
end
