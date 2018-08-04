# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST create' do
    context 'when a user tries to login using a valid email and password' do
      subject(:user_login) { post :create, params: user_session_params }

      setup do
        @user = FactoryBot.create(:user)
        user_login
      end

      it 'creates a session for them' do
        expect(user_login).to have_http_status(:redirect)
        expect(user_login).to redirect_to user_path(@user)
      end
    end

    context 'when a user tries to login using a username and password' do
      subject(:user_login) { post :create, params: user_session_params(email: '5her10ck_h01mes') }

      setup do
        @user = FactoryBot.create(:user)
        user_login
      end

      it 'creates a session for them' do
        expect(user_login).to have_http_status(:redirect)
        expect(user_login).to redirect_to user_path(@user)
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
