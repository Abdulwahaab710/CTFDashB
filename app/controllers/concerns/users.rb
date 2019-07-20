# frozen_string_literal: true

module Users
  extend ActiveSupport::Concern

  def user_is_enrolled_in_a_team?
    return if current_user&.organizer?

    return redirect_to join_team_path if current_user.team.nil?
  end
end
