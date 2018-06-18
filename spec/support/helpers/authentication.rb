# frozen_string_literal: true

module Helpers
  module Authentication
    def login_as(user)
      session[:user_session_id] = user.sessions.first.id
    end
  end
end
