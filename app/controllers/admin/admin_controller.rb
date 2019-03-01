# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :user_has_permission?

    include ::Sessions

    private

    def current_user
      @current_user ||= ::Session.find_by(id: session[:user_session_id])
      return @current_user.user if !@current_user.nil? && @current_user.class == ::Session
    end

    def user_has_permission?
      return if current_user&.organizer?

      render file: Rails.root.join('public', '404.html'),
             status: :forbidden,
             layout: false
    end
  end
end
