# frozen_string_literal: true

module Admin
  class CtfSettingsController < AdminController
    def edit
      update_settings
      update_boolean_settings
      flash[:success] = 'Settings has been updated'
      redirect_to action: 'show'
    end

    def show
      @ctf_settings = CtfSetting.order(:key)
    end

    private

    def update_settings
      settings_params.each do |param|
        setting = CtfSetting.find_or_create_by!(key: param[0])
        setting.update(value: param[1])
      end
    end

    def update_boolean_settings
      CtfSetting.where(value_type: 'Boolean').where.not( key: settings_params.keys ).update(value: 'false')
    end

    def settings_params
      params[:key]
    end
  end
end
