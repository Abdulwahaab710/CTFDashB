class CaptureTheFlagController < ApplicationController
  before_action :user_logged_in?
  def index
    @ctfs = CaptureTheFlag.all
  end

  def new
    @ctf = CaptureTheFlag.new
  end

  def show
    @ctf = CaptureTheFlag.find_by(id: params[:cid])
  end

  def create
    @ctf = CaptureTheFlag.new(ctf_params)
    if @ctf.save
      flash[:success] = 'You have successfully create a CTF'
      redirect_to @ctf
    else
      render :new
    end
  end

  private

  def ctf_params
    params.require(:capture_the_flag).permit(
      :name,
      :info,
      :max_teammates
    )
  end
end
