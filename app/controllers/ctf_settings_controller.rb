class CtfSettingsController < ApplicationController
  def edit
    settings_params.each do |param|
      setting = CtfSetting.find_or_create_by!(key: param[0])
      setting.update_attributes(value: param[1])
    end
    flash[:success] = 'Settings has been updated'
    redirect_to action: 'show'
  end

  def show
    @ctf_settings = CtfSetting.all
  end

  private

  def settings_params
    params[:key].zip(params[:value])
  end
end
