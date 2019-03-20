# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UserManagementsController, type: :controller do
  describe 'PATCH add_admin' do
    context 'when the user is not an admin' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        patch :add_admin, params: { id: user }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not grants admin permissions to a user' do
        expect(User.find(user.id).admin?).to eq(false)
      end
    end

    context 'when the user is an admin' do
      before :each do
        FactoryBot.create(:session, user: admin)
        login_as(admin)
        patch :add_admin, params: { id: user }
      end

      it 'returns success' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to /users' do
        expect(response).to redirect_to admin_users_path
      end

      it 'grants admin permissions to a user' do
        expect(User.find(user.id).admin?).to eq(true)
      end
    end
  end

  describe 'PATCH add_organizer' do
    context 'when the user is not an admin' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        patch :add_organizer, params: { id: user }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not grants organizer permissions to a user' do
        expect(User.find(user.id).organizer?).to eq(false)
      end
    end

    context 'when the user is an admin' do
      before :each do
        FactoryBot.create(:session, user: admin)
        login_as(admin)
        patch :add_organizer, params: { id: user }
      end

      it 'returns success' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to /users' do
        expect(response).to redirect_to admin_users_path
      end

      it 'grants organizer permissions to a user' do
        expect(User.find(user.id).organizer?).to eq(true)
      end
    end
  end

  describe 'DELETE remove_admin' do
    context 'when the user is not an admin' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        delete :remove_admin, params: { id: admin }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not remove admin permissions from a user' do
        expect(User.find(admin.id).admin?).to eq(true)
      end
    end

    context 'when the user is an admin' do
      before :each do
        FactoryBot.create(:session, user: admin)
        login_as(admin)
        delete :remove_admin, params: { id: admin }
      end

      it 'returns success' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to /users' do
        expect(response).to redirect_to admin_users_path
      end

      it 'remove admin permissions from a user' do
        expect(User.find(admin.id).admin?).to eq(false)
      end
    end
  end

  describe 'DELETE remove_organizer' do
    context 'when the user is not an admin' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        delete :remove_organizer, params: { id: organizer_user }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not remove organizer permissions from a user' do
        expect(User.find(organizer_user.id).organizer?).to eq(true)
      end
    end

    context 'when the user is an admin' do
      before :each do
        FactoryBot.create(:session, user: admin)
        login_as(admin)
        patch :remove_organizer, params: { id: organizer_user }
      end

      it 'returns success' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to /users' do
        expect(response).to redirect_to admin_users_path
      end

      it 'remove organizer permissions from a user' do
        expect(User.find(organizer_user.id).organizer?).to eq(false)
      end
    end
  end

  describe 'PATCH activate' do
    context 'when the user is not an admin' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        patch :activate, params: { id: deactivated_user }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not activate deactivated users' do
        expect(User.find(deactivated_user.id).active?).to eq(false)
      end
    end

    context 'when the user is an admin' do
      before :each do
        FactoryBot.create(:session, user: admin)
        login_as(admin)
        patch :activate, params: { id: deactivated_user }
      end

      it 'returns success' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to /users' do
        expect(response).to redirect_to admin_users_path
      end

      it 'activates deactivated users' do
        expect(User.find(deactivated_user.id).active?).to eq(true)
      end
    end
  end

  describe 'DELETE deactivate' do
    context 'when the user is not an admin' do
      before :each do
        FactoryBot.create(:session, user: user)
        login_as(user)
        delete :deactivate, params: { id: user }
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not deactivate activated users' do
        expect(User.find(user.id).active?).to eq(true)
      end
    end

    context 'when the user is an admin' do
      before :each do
        FactoryBot.create(:session, user: admin)
        login_as(admin)
        delete :deactivate, params: { id: user }
      end

      it 'returns success' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to /users' do
        expect(response).to redirect_to admin_users_path
      end

      it 'deactivates activated users' do
        expect(User.find(user.id).active?).to eq(false)
      end
    end
  end

  private

  def user
    @user ||= FactoryBot.create(:user)
  end

  def admin
    @admin ||= FactoryBot.create(:user, admin: true)
  end

  def deactivated_user
    @deactivated_user ||= FactoryBot.create(:user, active: false)
  end

  def organizer_user
    @organizer_user ||= FactoryBot.create(:user, organizer: true)
  end
end
