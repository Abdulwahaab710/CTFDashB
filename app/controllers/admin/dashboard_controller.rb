# frozen_string_literal: true

module Admin
  class DashboardController < AdminController
    def index
      if params[:show] == 'all'
        @user_challenges = Challenge.includes(:category)&.group_by { |c| c.category }
      else
        @user_challenges = current_user&.challenges&.includes(:category)&.group_by { |c| c.category }
      end
      @total_teams = Team.count
    end
  end
end
