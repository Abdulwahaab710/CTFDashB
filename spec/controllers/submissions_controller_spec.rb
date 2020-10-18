# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  describe 'POST create' do
    before :each do
      @challenge = FactoryBot.create(:challenge, max_tries: 1)
      FactoryBot.create(:flag_regex)
    end

    context 'when the user is logged in and the challenges exits' do
      before(:each) do
        FactoryBot.create(:session, user: user)
        login_as(user)
      end

      let(:response) do
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{5QL1_15_AWES0ME}' }
        }, format: :js
      end

      it 'broadcast the new scores' do
        byebug
        expect { response }.to have_broadcasted_to('scores_channel')
      end

      it 'returns success' do
        expect(response).to be_successful
        expect(flash[:success]).to eq 'Woohoo, you have successfully submitted your flag'
      end

      it 'adds the challenge points to the team score' do
        response
        expect(Team.find_by(id: user.team.id).score).to eq(100)
      end
    end

    context 'when the user is logged in and the challenge is not active' do
      before(:each) do
        FactoryBot.create(:session, user: user)
        @deactivated_challenge = FactoryBot.create(:challenge, category: @challenge.category, active: false)
        login_as(user)
      end

      let(:response) do
        post :create, params: {
          category_id: @deactivated_challenge.category_id,
          id: @deactivated_challenge.id,
          submission: { flag: 'flag{5QL1_15_AWES0ME}' }
        }, format: :js
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
        expect(flash[:danger]).to eq 'Challenge was not found'
      end
    end

    context 'when the user is an organizer and the flag is correct' do
      before(:each) do
        FactoryBot.create(:session, user: organizer)
        login_as(organizer)
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{5QL1_15_AWES0ME}' }
        }, format: :js
      end

      it 'returns success' do
        expect(response).to be_successful
        expect(flash[:success]).to eq 'Woohoo, you have successfully submitted your flag'
      end

      it 'does not update the score' do
        expect(Team.find_by(id: organizer.team.id).score).to eq(0)
      end

      it 'does not add a submission' do
        expect(Submission.count).to eq(0)
      end
    end

    context 'when the user is an organizer and the flag is incorrect' do
      before(:each) do
        FactoryBot.create(:session, user: organizer)
        login_as(organizer)
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{invalid_flag}' }
        }, format: :js
      end

      it 'returns 422' do
        expect(response).to have_http_status(422)
        expect(flash[:danger]).to eq 'Flag is incorrect'
      end

      it 'does not add a submission' do
        expect(Submission.count).to eq(0)
      end
    end

    context 'when the user submit an invalid flag' do
      before(:each) do
        FactoryBot.create(:session, user: user)
        login_as(user)
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{INVALID_FLAG}' }
        }, format: :js
      end

      it 'returns 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error' do
        expect(flash[:danger]).to eq('Flag is incorrect')
      end
    end

    context 'when the user submit an invalid flag format' do
      before(:each) do
        FactoryBot.create(:session, user: user)
        login_as(user)
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{invalid flag}format' }
        }, format: :js
      end

      it 'returns 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error if the flag format is invalid' do
        expect(flash[:danger]).to eq('Invalid flag format')
      end
    end

    context 'when the user has reached the maximum number of tries' do
      before(:each) do
        FactoryBot.create(:session, user: user)
        FactoryBot.create(
          :submission, user: user, team: user.team, challenge: @challenge, category: @challenge.category
        )
        login_as(user)
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{invalid flag}' }
        }, format: :js
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'flashes with You have reached the maximum number of tries.' do
        expect(flash[:danger]).to eq('You have reached the maximum number of tries.')
      end
    end

    context 'when the user has already submitted a valid flag' do
      before :each do
        FactoryBot.create(:session, user: user)
        FactoryBot.create(
          :submission, user: user, team: user.team, challenge: @challenge,
                       category: @challenge.category, valid_submission: true
        )
        login_as(user)
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{5QL1_15_AWES0ME}' }
        }, format: :js
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
