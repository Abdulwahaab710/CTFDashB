module Api
  class ApplicationController < ActionController::Base
    before_action do
      return if request.content_type == 'application/json' || request.content_type == 'application/graphql'

      head :bad_request
    end
  end
end
