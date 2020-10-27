# frozen_string_literal: true

class ScoresController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[index]

  def index
    if CtfSetting.scoreboard_enabled?
      @teams = Team.order(score: :desc, last_valid_submission_at: :asc).limit(25)
      @submissions = Submission.includes(:team, :challenge, :category).where(valid_submission: true).limit(25)
        .order(created_at: :desc)
    else
      @teams = Team.pluck(:id).map { |t| BogusTeam.new(t, '?', '1337') }
      @submissions = []
    end
  end

  private

  BogusTeam = Struct.new(:id, :name, :score)
end
