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

      add_max_tries_to_challenges_without_max_tries
    end

    def update_boolean_settings
      CtfSetting.where(value_type: 'Boolean').where.not( key: settings_params.keys ).update(value: 'false')
    end

    def settings_params
      params[:key]
    end

    def add_max_tries_to_challenges_without_max_tries
      return if settings_params.keys.include?("unlimited_retries") || !CtfSetting.unlimited_retries?

      Challenge.where(max_tries: nil).update_all(max_tries: CtfSetting.default_max_tries.to_i)
    end
  end
end
