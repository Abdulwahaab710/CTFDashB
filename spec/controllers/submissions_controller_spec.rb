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

      it 'adds the challenge points to the team score' do
        expect(Team.find_by(id: user.team.id).score).to eq(100)
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
  end

  private

  def user
    @user ||= FactoryBot.create(:user)
  end
end
