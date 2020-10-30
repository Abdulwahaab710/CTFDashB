# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :return_not_found_if_challenge_is_not_active, only: :create
  before_action :return_forbidden_if_reached_max_tries, only: :create
  before_action :return_forbidden_if_submitted_valid_flag_before, only: :create

  include Submissions

  def create
    @challenge = challenge
    return head 404 if @challenge.nil?
    return invalid_flag unless validate_flag_format(submitted_flag)

    add_submission
    verify_flag
  end

  private

  def verify_flag
    if FlagVerifier.new(@challenge, submitted_flag).call
      successful_submission
    else
      unsuccessful_submission
    end
  end

  def unsuccessful_submission
    flash.now[:danger] = 'Flag is incorrect'
    @max_tries = remaining_tries
    @submission&.update(valid_submission: false, flag: submitted_flag)
    respond_to do |f|
      f.js { render 'unsuccessful_submission', status: :unprocessable_entity }
    end
  end

  def submitted_flag
    params.require(:submission).permit(:flag)[:flag]
  end

  def challenge
    @challenge ||= Challenge.find_by(id: params[:id], category_id: params[:category_id], active: true)
  end

  def reached_the_max_number_of_tries?
    number_of_tries.to_i >= challenge&.max_tries
  end

  def remaining_tries
    challenge&.max_tries.to_i - number_of_tries
  end

  def number_of_tries
    challenge&.submissions&.where(team: current_user&.team)&.count
  end

  def return_forbidden_if_reached_max_tries
    return true if CtfSetting.unlimited_retries?
    return true unless reached_the_max_number_of_tries?

    flash.now[:danger] = 'You have reached the maximum number of tries.'
    respond_to do |f|
      f.js { render 'forbidden_submission', status: :forbidden }
    end
  end

  def return_not_found_if_challenge_is_not_active
    return true unless challenge.nil?

    flash.now[:danger] = 'Challenge was not found'
    respond_to do |f|
      f.js { render 'forbidden_submission', status: :not_found }
    end
  end
end
