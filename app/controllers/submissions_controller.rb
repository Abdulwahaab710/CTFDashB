# frozen_string_literal: true

class SubmissionsController < ApplicationController
  def create
    @challenge = Category.find_by(id: params[:category_id]).challenges.find_by(id: params[:id])
    return head 404 if @challenge.nil?
    add_submission
    verify_flag
  end

  private

  def verify_flag
    flag = BCrypt::Password.new(@challenge&.flag)
    if flag == submitted_flag
      flash[:success] = 'Woohoo, you have successfully submitted your flag'
      @submission.update_attrubites(valid_submission: true)
      render_alert
    else
      @submission.update_attrubites(valid_submission: true, flag: submitted_flag)
      respond_to do |f|
        f.js { render js: 'unsuccessful_submission', status: :unprocessable_entity }
      end
    end
  end

  def render_alert
    respond_to do |f|
      f.js { render 'successful_submission', status: :ok }
    end
  end

  def submitted_flag
    params.require(:submission).permit(:flag)[:flag]
  end

  def build_submission_signature
    salt = Rails.application.secrets.submission_salt
    Digest::SHA256.hexdigest("#{@challenge.id}#{current_user.team.id}#{current_user.id}#{submitted_flag}#{salt}")
  end

  def add_submission
    @submission = Submission.new(
      team: current_user.team,
      user: current_user,
      category: @challenge.category,
      challenge: @challenge,
      submission_hash: build_submission_signature
    )
  end
end
