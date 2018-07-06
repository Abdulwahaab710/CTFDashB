# frozen_string_literal: true

class SubmissionsController < ApplicationController
  def create
    @challenge = Category.find_by(id: params[:category_id]).challenges.find_by(id: params[:id])
    return head 404 if @challenge.nil?
    verify_flag
  end

  private

  def verify_flag
    flag = BCrypt::Password.new(@challenge&.flag)
    if flag == submitted_flag
      flash[:success] = 'Woohoo, you have successfully submitted your flag'
      render_alert
    else
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
end
