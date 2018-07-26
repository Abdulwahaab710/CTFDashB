# frozen_string_literal: true

class ScoresController < ApplicationController
  def index
    @teams = Team.order(:score)
  end
end
