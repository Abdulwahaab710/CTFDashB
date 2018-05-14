# frozen_string_literal: true

module CtfSettingsHelper
  def ctf_name
    CtfSetting.find_by(key: 'ctf_name')&.value
  end

  def ctf_logo
    CtfSetting.find_by(key: 'ctf_logo')&.value
  end
end
