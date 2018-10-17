# frozen_string_literal: true

module CtfSettings
  def ctf_name
    CtfSetting.find_by(key: 'ctf_name')&.value
  end

  def ctf_has_started?
    return if current_user&.organizer?
    return render 'shared/countdown' unless ctf_started?
  end

  def ctf_started?
    Time.zone.now.to_f > CtfSetting.find_by(key: 'start_time')&.value.to_f
  end
end
