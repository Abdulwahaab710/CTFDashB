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
    if flag == submitted_flag
      successful_submission
    else
      unsuccessful_submission
    end
  end

  def successful_submission
    @submission.update(valid_submission: true)
    update_score
    render_alert
  end

  def unsuccessful_submission
    flash[:danger] = 'Flag is incorrect'
    @submission.update(valid_submission: false, flag: submitted_flag)
    respond_to do |f|
      f.js { render 'unsuccessful_submission', status: :unprocessable_entity }
    end
  end

  def invalid_flag
    flash[:danger] = 'Invalid flag format'
    respond_to do |f|
      f.js { render 'unsuccessful_submission', status: :unprocessable_entity }
    end
  end

  def render_alert
    flash[:success] = 'Woohoo, you have successfully submitted your flag'
    respond_to do |f|
      f.js { render 'successful_submission', status: :ok }
    end
  end

  def build_submission_signature
    salt = Rails.application.secrets.submission_salt
    Digest::SHA256.hexdigest("#{@challenge.id}#{current_user&.team&.id}#{submitted_flag}#{salt}")
  end

  def submitted_flag
    params.require(:submission).permit(:flag)[:flag]
  end

  def update_score
    score = current_user.team.score.to_i + @challenge.points.to_i
    current_user.team.update(score: score)
  end

  def flag
    @flag ||= BCrypt::Password.new(@challenge&.flag)
  end
end
