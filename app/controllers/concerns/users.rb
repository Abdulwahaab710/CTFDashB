# frozen_string_literal: true

module Users
  extend ActiveSupport::Concern

  def user_has_permission?
    return if current_user&.organizer?
    render file: Rails.root.join('public', '404.html'),
           status: :forbidden,
           layout: false
  end
end
