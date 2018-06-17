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

  private

  def asset_exists?(asset)
    return !!Rails.application.precompiled_assets.include?(asset) if Rails.configuration.assets.compile
    !!Rails.application.assets_manifest.assets[asset].present?
  end
end
