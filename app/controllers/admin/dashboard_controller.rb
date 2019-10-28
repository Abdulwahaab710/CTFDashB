# frozen_string_literal: true

module Admin
  class DashboardController < AdminController
    def index
      @user_challenges = current_user&.challenges&.includes(:category)&.group_by { |c| c.category }
      @total_teams = Team.count
    end
  end
end
