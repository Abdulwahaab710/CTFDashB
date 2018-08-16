# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET index' do
    context 'when there are categories' do
      before :each do
        @challenge = FactoryBot.create(:challenge)
        get :index
      end

      it 'returns success' do
        expect(response).to be_successful
      end

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'list all the challenges' do
        expect(assigns[:challenges]).to eq([@challenge])
        expect(assigns[:categories]).to eq([@challenge.category])
      end
    end

    context 'when there are no categories' do
      before :each do
        get :index
      end

      it 'returns success' do
        expect(response).to be_successful
      end

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'returns empty list for challenges and categories' do
        expect(assigns[:challenges]).to eq([])
        expect(assigns[:categories]).to eq([])
      end
    end
  end

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

      it 'renders new' do
        expect(response).to render_template('new')
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

  describe 'POST new' do
    context 'when the user is an organizer' do
      before :each do
        FactoryBot.create(:session, user: organizer)
        login_as organizer
        @category_params = FactoryBot.attributes_for(:category)
        post :create, params: { category: @category_params }
      end

      it 'creates a challenge' do
        expect(Category.first&.name).to eq(@category_params[:name])
      end

      it 'redirects to the challenge' do
        category = Category.first
        expect(response).to redirect_to(category_path(category))
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        @category_params = FactoryBot.attributes_for(:category)
        post :create, params: { challenge: @category_params }
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
        category = FactoryBot.create(:category)
        get :edit, params: { id: category.id }
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
        @category = FactoryBot.create(:category)
        @category_params = @category.attributes
        @category_params['name'] = 'reverse engineering'
        patch :update, params: { id: @category.id, category: @category_params }
      end

      it 'redirects to category' do
        expect(response).to redirect_to(category_path(@category))
      end

      it 'updates the category record' do
        expect(Category.first.name).to eq(@category_params['name'])
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        @category = FactoryBot.create(:category)
        @category_params = @category.attributes
        @category_params[:name] = 'reverse engineering'
        patch :update, params: { id: @category.id, category: @category_params }
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
        category = FactoryBot.create(:category)
        delete :destroy, params: { id: category.id }
      end

      it 'redirects to categories' do
        expect(response).to redirect_to(categories_path)
      end

      it 'deletes the category' do
        expect(Category.count).to eq(0)
      end
    end

    context 'when the user is not an organizer' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as user
        category = FactoryBot.create(:category)
        delete :destroy, params: { id: category.id }
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
