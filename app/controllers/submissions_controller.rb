# frozen_string_literal: true

class SubmissionsController < ApplicationController

  def create
    @challenge = Category.find_by(id: params[:category_id]).challenges.find_by(id: params[:id])
    if @challenge
      flag = BCrypt::Password.new(@challenge&.flag)
      if submitted_flag == flag
        puts 'hello'
      else
        respond_to do |f|
          f.js { render json: 'Invalid flag', status: :unprocessable_entity }
        end
      end
    else
      head 404
    end
  end

  private

  def submitted_flag
    params.require(:submission).permit(:flag)
  end
end
