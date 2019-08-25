# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Sessions
  before_action :user_logged_in?

  private

  def user_logged_in?
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def render_liquid_template(template, data: {})
    render html: Liquid::Template.parse(template).render!(data, strict_variables: true).html_safe
  end
end
