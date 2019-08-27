# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET show' do
    context 'when the page is exits' do
      before :each do
        @page = FactoryBot.create(:page)
        FactoryBot.create(:session, user: user)
        login_as user
        get :show, params: { path: @page.path }
      end

      it 'returns success' do
        expect(response).to be_successful
      end

      it 'renders the page html content' do
        expect(response.body).to eq(@page.html_content)
      end
    end

    context 'when the page doesn\'t exits' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        get :show, params: { path: 'some-not-found-page' }
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  private

  def user
    @user ||= FactoryBot.create(:user)
  end
end
