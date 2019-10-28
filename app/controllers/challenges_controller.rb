# frozen_string_literal: true

class ChallengesController < ApplicationController
  before_action :user_logged_in?, except: %i[index]
  before_action :ctf_has_started?
  before_action :user_is_enrolled_in_a_team?, only: :show
  before_action :fetch_categories
  before_action :fetch_team_submissions

  include Users
  include CtfSettings

  def index
    @challenges = Challenge.active.includes(:category, :challenge_files_attachments).page(params[:page] || 1)
  end

  def show
    @challenge_submission = Submission.new
    @challenge = challenge
    @challenge_submissions = @challenge.submissions.where(valid_submission: true)
  end

  private

  def challenge
    @challenge ||= Challenge.find_by!(id: params[:id], category_id: params[:category_id], active: true)
  end

  def fetch_categories
    @categories = Category.all
  end

  def fetch_team_submissions
    @team_submissions ||= Submission.where(team: current_user&.team).group(:challenge_id).count
  end
end
