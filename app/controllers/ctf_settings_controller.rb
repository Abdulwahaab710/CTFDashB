class CtfSettingsController < ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def show
    @ctf_settings = CtfSetting.all
  end
end
