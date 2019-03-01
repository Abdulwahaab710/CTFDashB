# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengesController, type: :controller do
  describe 'GET index' do
    before :each do
      get :index
    end

    context 'when there is challenges' do
      it 'returns success' do
        expect(response).to be_successful
      end
    end

    context 'when there is no challenges' do
      it 'returns success' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET show' do
    context 'when the user is logged in' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        challenge = FactoryBot.create(:challenge)
        get :show, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'returns success' do
        expect(response).to be_successful
      end
    end

    context 'when the user is not logged in' do
      before :each do
        challenge = FactoryBot.create(:challenge)
        get :show, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'redirects the user to the login page' do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  private

  def user
    @user ||= FactoryBot.create(:user)
  end
end
