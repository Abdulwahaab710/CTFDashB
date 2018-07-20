# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  describe 'POST create' do
    context 'when the user is logged in and the challenges exits' do
      before(:each) do
        FactoryBot.create(:session, user: user)
        @challenge = FactoryBot.create(:challenge)
        login_as(user)
        post :create, params: {
          category_id: @challenge.category_id,
          id: @challenge.id,
          submission: { flag: 'flag{5QL1_15_AWES0ME}' }
        }, format: :js
      end

      it 'returns success' do
        expect(response).to be_successful
      end
    end
  end

  private

  def user
    @user ||= FactoryBot.create(:user)
  end
end
