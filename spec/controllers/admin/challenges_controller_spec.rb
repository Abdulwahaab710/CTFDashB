# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ChallengesController, type: :controller do
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
        expect(Challenge.first&.flag).to eq(@challenge_params[:flag])
      end

      it 'redirects to the challenge' do
        challenge = Challenge.first
        expect(response).to redirect_to(admin_category_challenge_path(challenge.category, challenge))
      end
    end

    context 'when hash_flag is enabled' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        FactoryBot.create(:ctf_setting, key: 'hash_flag', value: 'true', value_type: 'Boolean')
        login_as organizer
        category = FactoryBot.create(:category)
        @challenge_params = FactoryBot.attributes_for(:challenge, category_id: category.id)
        post :create, params: { challenge: @challenge_params }
      end

      it 'creates a challenge with a hashed flag' do
        expect(BCrypt::Password.new(Challenge.first&.flag)).to eq(@challenge_params[:flag])
      end
    end

    context 'when the flag is a hash' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        category = FactoryBot.create(:category)
        @challenge_params = FactoryBot.attributes_for(
          :challenge,
          category_id: category.id,
          flag: "/Athis is a REGEX FLAG/Z",
          case_insensitive: true
        )

        post :create, params: { challenge: @challenge_params, flag_type: 'regex' }
      end

      it 'creates a challenge with a regex flag' do
        expect(FlagVerifier.new(Challenge.first, "this is a REGEX FLAG").call).to be true
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
        expect(response).to redirect_to(admin_category_challenge_path(@challenge.category, @challenge))
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
        expect(response).to redirect_to(admin_category_challenge_path(@challenge.category, @challenge))
      end

      it 'updates the flag' do
        expect(Challenge.first&.flag).to eq(@new_flag)
      end

      it 'flashes with You have successfully updated the challenge flag' do
        expect(flash[:success]).to eq('You have successfully updated the challenge flag')
      end
    end

    context 'hash_flag is enabled' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        FactoryBot.create(:ctf_setting, key: 'hash_flag', value: 'true', value_type: 'Boolean')
        login_as organizer
        @challenge = FactoryBot.create(:challenge)
        @new_flag = 'flag{new_flag}'
        patch :update_flag, params: {
          category_id: @challenge.category_id, id: @challenge.id, challenge: { flag: @new_flag }
        }
      end

      it 'redirects to the challenge' do
        expect(response).to redirect_to(admin_category_challenge_path(@challenge.category, @challenge))
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

    context 'when the organizer updates an invalid flag and a user has submitted a valid flag' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        @challenge = FactoryBot.create(:challenge)
        @correct_flag = 'flag{correct_flag}'
        FactoryBot.create(
          :submission,
          challenge: @challenge,
          category: @challenge.category,
          flag: @correct_flag,
          valid_submission: false
        )
      end

      it 'updates the submission by setting the flag to empty and changing the submission to valid submissions' do
        expect {
          patch :update_flag, params: {
            category_id: @challenge.category.id, id: @challenge.id, challenge: { flag: @correct_flag }
          }
        }.to change{ Submission.where(valid_submission: true).count }.from(0).to(1)
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
        expect(response).to redirect_to(admin_category_challenges_path(@challenge.category))
      end

      it 'activates the challenge' do
        expect(Challenge.active.count).to eq(1)
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
        expect(response).to redirect_to(admin_category_challenges_path(@challenge.category))
      end

      it 'deactivates the challenge' do
        expect(Challenge.active.count).to eq(0)
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
