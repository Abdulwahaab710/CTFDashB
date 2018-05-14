# frozen_string_literal: true

module CtfSettings
  def ctf_name
    CtfSetting.find_by(key: 'ctf_name')&.value
  end
end
