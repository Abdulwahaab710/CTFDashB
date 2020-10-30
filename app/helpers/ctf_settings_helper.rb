# frozen_string_literal: true

module CtfSettingsHelper
  def ctf_name
    CtfSetting.find_by(key: 'ctf_name')&.value
  end

  def ctf_logo
    CtfSetting.find_by(key: 'ctf_logo')&.value
  end

  def browser_icon(browser)
    return 'browser.png' unless asset_exists? "#{browser}.svg"
    "#{browser}.svg"
  end

  def default_max_tries
    CtfSetting.default_max_tries
  end

  def unlimited_retries?
    CtfSetting.unlimited_retries?
  end

  def general_submission_enabled?
    CtfSetting.general_submission_enabled?
  end

  def ctf_setting_tag(ctf_setting)
    case ctf_setting.value_type
    when "Boolean"
      check_box_tag(
        "key[#{ctf_setting.key}]", true, ActiveModel::Type::Boolean.new.cast(ctf_setting.value), style: 'width: auto'
      )
    when "Time"
      datetime_field_tag("key[#{ctf_setting.key}]", ctf_setting.value, style: 'width: 100%; text-align: center;')
    when "String"
      text_field_tag("key[#{ctf_setting.key}]", ctf_setting.value, style: 'width: 100%; text-align: center;')
    end
  end

  private

  def asset_exists?(asset)
    return !!Rails.application.precompiled_assets.include?(asset) if Rails.configuration.assets.compile
    !!Rails.application.assets_manifest.assets[asset].present?
  end
end
