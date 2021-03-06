# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :ctf_has_started?
  before_action :submission_closed?

  include Sessions
  include CtfSettings

  private

  def render_404
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end
end
