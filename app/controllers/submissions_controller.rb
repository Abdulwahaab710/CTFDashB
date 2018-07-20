# frozen_string_literal: true

class SubmissionsController < ApplicationController
  include Submissions

  def create
    @challenge = Category.find_by(id: params[:category_id]).challenges.find_by(id: params[:id])
    return head 404 if @challenge.nil?
    return invalid_flag unless validate_flag_format(submitted_flag)
    add_submission
    verify_flag
  end

  private

  def verify_flag
    flag = BCrypt::Password.new(@challenge&.flag)
    if flag == submitted_flag
      flash[:success] = 'Woohoo, you have successfully submitted your flag'
      @submission.update(valid_submission: true)
      render_alert
    else
      flash[:danger] = 'Flag is incorrect'
      @submission.update(valid_submission: false, flag: submitted_flag)
      respond_to do |f|
        f.js { render 'unsuccessful_submission', status: :unprocessable_entity }
      end
    end
  end

  def invalid_flag
    flash[:danger] = 'Invalid flag format'
    respond_to do |f|
      f.js { render 'unsuccessful_submission', status: :unprocessable_entity }
    end
  end

  def render_alert
    respond_to do |f|
      f.js { render 'successful_submission', status: :ok }
    end
  end

  def build_submission_signature
    salt = Rails.application.secrets.submission_salt
    Digest::SHA256.hexdigest("#{@challenge.id}#{current_user&.team&.id}#{current_user.id}#{submitted_flag}#{salt}")
  end

  def add_submission
    @submission = Submission.find_or_create_by!(
      team: current_user.team,
      user: current_user,
      category: @challenge.category,
      challenge: @challenge,
      submission_hash: build_submission_signature
    )
  end

  def submitted_flag
    params.require(:submission).permit(:flag)[:flag]
  end
end
