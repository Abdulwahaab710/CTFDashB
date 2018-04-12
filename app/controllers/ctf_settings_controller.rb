class CtfSettingsController < ApplicationController
  def new
  end

  def create
  end

  def edit
    settings_params.each do |param|
      setting = CtfSetting.find_or_create_by!(key: param[0])
      setting.update_attributes(value: param[1])
    end
  end

  def show
    @ctf_settings = CtfSetting.all
  end

  private

  def settings_params
    params[:key].zip(params[:value])
  end
end
