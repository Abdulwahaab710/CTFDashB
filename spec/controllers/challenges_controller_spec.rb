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

  describe 'GET new' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        get :new
      end

      it 'returns success' do
        expect(response).to be_successful
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        get :new
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST create' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        category = FactoryBot.create(:category)
        @challenge_params = FactoryBot.attributes_for(:challenge, category_id: category.id)
        post :create, params: { challenge: @challenge_params }
      end

      it 'creates a challenge' do
        expect(Challenge.first&.title).to eq(@challenge_params[:title])
      end

      it 'redirects to the challenge' do
        challenge = Challenge.first
        expect(response).to redirect_to(category_challenge_path(challenge.category, challenge))
      end
    end

    context 'when the user is an organizer and the params is missing a field' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        category = FactoryBot.create(:category)
        challenge_params = FactoryBot.attributes_for(:challenge, category_id: category.id)
        challenge_params.delete(:flag)
        post :create, params: { challenge: challenge_params }
      end

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        category = FactoryBot.create(:category)
        @challenge_params = FactoryBot.attributes_for(:challenge, category_id: category.id)
        post :create, params: { challenge: @challenge_params }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET edit' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        challenge = FactoryBot.create(:challenge)
        get :edit, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'returns success' do
        expect(response).to be_successful
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        challenge = FactoryBot.create(:challenge)
        get :edit, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH update' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        @challenge = FactoryBot.create(:challenge)
        @challenge_params = @challenge.attributes
        @challenge_params[:title] = 'XSS baby'
        patch :update, params: { category_id: @challenge.category_id, id: @challenge.id, challenge: @challenge_params }
      end

      it 'returns success' do
        expect(response).to redirect_to(category_challenge_path(@challenge.category, @challenge))
      end

      it 'updates the challenge record' do
        expect(Challenge.first&.title).to eq(@challenge_params[:title])
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        @challenge = FactoryBot.create(:challenge)
        @challenge_params = @challenge.attributes
        @challenge_params[:title] = 'XSS baby'
        patch :update, params: { category_id: @challenge.category_id, id: @challenge.id, challenge: @challenge_params }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH update_flag' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        @challenge = FactoryBot.create(:challenge)
        @new_flag = 'flag{new_flag}'
        patch :update_flag, params: {
          category_id: @challenge.category_id, id: @challenge.id, challenge: { flag: @new_flag }
        }
      end

      it 'redirects to the challenge' do
        expect(response).to redirect_to(category_challenge_path(@challenge.category, @challenge))
      end

      it 'updates the flag' do
        expect(BCrypt::Password.new(Challenge.first&.flag)).to eq(@new_flag)
      end

      it 'flashes with You have successfully updated the challenge flag' do
        expect(flash[:success]).to eq('You have successfully updated the challenge flag')
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        @challenge = FactoryBot.create(:challenge)
        @new_flag = 'flag{new_flag}'
        patch :update_flag, params: {
          category_id: @challenge.category_id, id: @challenge.id, challenge: { flag: @new_flag }
        }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
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

  describe 'DELETE destroy' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        challenge = FactoryBot.create(:challenge)
        delete :destroy, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'returns success' do
        expect(response).to be_successful
      end

      it 'deletes the challenge' do
        expect(Challenge.count).to eq(0)
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        challenge = FactoryBot.create(:challenge)
        delete :destroy, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH activate' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        @challenge = FactoryBot.create(:challenge, active: false)
        patch :activate, params: { category_id: @challenge.category_id, id: @challenge.id }
      end

      it 'redirects to the category of the challenge' do
        expect(response).to redirect_to(category_challenges_path(@challenge.category))
      end

      it 'activates the challenge' do
        expect(Challenge.where(active: true).count).to eq(1)
        expect(Challenge.where(active: false).count).to eq(0)
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        challenge = FactoryBot.create(:challenge, active: false)
        patch :activate, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH deactivate' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        @challenge = FactoryBot.create(:challenge)
        patch :deactivate, params: { category_id: @challenge.category_id, id: @challenge.id }
      end

      it 'redirects to the category of the challenge' do
        expect(response).to redirect_to(category_challenges_path(@challenge.category))
      end

      it 'deactivates the challenge' do
        expect(Challenge.where(active: true).count).to eq(0)
        expect(Challenge.where(active: false).count).to eq(1)
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        challenge = FactoryBot.create(:challenge)
        patch :deactivate, params: { category_id: challenge.category_id, id: challenge.id }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
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
