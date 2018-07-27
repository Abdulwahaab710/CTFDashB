# frozen_string_literal: true

class ScoresController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[index]

  def index
    @teams = Team.order(:score)
  end
end
