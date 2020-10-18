# frozen_string_literal: true

class ScoresController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[index]

  def index
    if CtfSetting.scoreboard_enabled?
      @teams = Team.order(score: :desc)
    else
      @teams = Team.pluck(:id).map { |t| BogusTeam.new(t, '?', '1337') }
    end
  end

  private

  BogusTeam = Struct.new(:id, :name, :score)
end
