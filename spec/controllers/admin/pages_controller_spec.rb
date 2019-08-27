# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PagesController, type: :controller do
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
        @page_params = FactoryBot.attributes_for(:page)
        post :create, params: { page: @page_params }
      end

      it 'creates a page' do
        expect(Page&.first&.path).to eq(@page_params[:path])
      end

      it 'redirects to index' do
        expect(response).to redirect_to(admin_pages_path)
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        @page_params = FactoryBot.attributes_for(:page)
        post :create, params: { page: @page_params }
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
        page = FactoryBot.create(:page)
        get :edit, params: { path: page.path }
      end

      it 'returns success' do
        expect(response).to be_successful
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        page = FactoryBot.create(:page)
        get :edit, params: { path: page.path }
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
        page = FactoryBot.create(:page)
        @page_params = page.attributes
        @page_params['path'] = 'new-path'
        patch :update, params: { path: page.path, page: @page_params }
      end

      it 'returns success' do
        expect(response).to redirect_to(admin_pages_path)
      end

      it 'updates the page record' do
        expect(Page.first&.path).to eq(@page_params['path'])
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        @page = FactoryBot.create(:page)
        @page_params = @page.attributes
        @page_params['path'] = 'new-path'
        patch :update, params: { id: @page.id, page: @page_params }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        page = FactoryBot.create(:page)
        delete :destroy, params: { path: page.path }
      end

      it 'redirects to index' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_pages_path)
      end

      it 'deletes the page' do
        expect(Page.count).to eq(0)
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        page = FactoryBot.create(:page)
        delete :destroy, params: { path: page.path }
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
