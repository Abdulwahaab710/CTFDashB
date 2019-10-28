# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET show' do
    context 'when the category exist' do
      before :each do
        @challenge = FactoryBot.create(:challenge)
        get :show, params: { id: @challenge.category.id }
      end

      it 'returns success' do
        expect(response).to be_successful
      end

      it 'renders show' do
        expect(response).to render_template('show')
      end

      it 'list all the challenges' do
        expect(assigns[:categories]).to eq([@challenge.category])
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
