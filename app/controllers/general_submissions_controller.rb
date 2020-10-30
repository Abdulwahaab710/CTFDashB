# frozen_string_literal: true

class GeneralSubmissionsController < ApplicationController
  before_action :return_not_found_if_general_submission_is_not_enabled
  before_action :valid_flag_format?
  before_action :return_not_found_if_challenge_is_not_active
  before_action :return_forbidden_if_submitted_valid_flag_before

  include Submissions

  def create
    @challenge = challenge
    return unsuccessful_submission if @challenge.nil?

    add_submission
    successful_submission
  end

  private

  def unsuccessful_submission
    flash.now[:danger] = 'Flag is incorrect'
    respond_to do |f|
      f.js { render 'submissions/unsuccessful_submission', status: :unprocessable_entity }
    end
  end

  def challenge
    @challenge ||= if current_user.organizer?
        Challenge.find_by(flag: params[:flag])
      else
        Challenge.find_by(active: true, flag: params[:flag])
      end
  end

  def submitted_flag
    params[:flag]
  end

  def valid_flag_format?
    return invalid_flag unless validate_flag_format(submitted_flag)
  end

  def return_not_found_if_general_submission_is_not_enabled
    return render_404 unless CtfSetting.general_submission_enabled?
  end
end
