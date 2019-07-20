# frozen_string_literal: true

module Admin
  class CtfSettingsController < AdminController
    def edit
      settings_params.each do |param|
        setting = CtfSetting.find_or_create_by!(key: param[0])
        setting.update(value: param[1])
      end
      flash[:success] = 'Settings has been updated'
      redirect_to action: 'show'
    end

    def show
      @ctf_settings = CtfSetting.all
    end

    private

    def settings_params
      params[:key]
    end
  end
end
