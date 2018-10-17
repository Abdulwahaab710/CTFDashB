# frozen_string_literal: true

module CtfSettings
  def ctf_name
    CtfSetting.find_by(key: 'ctf_name')&.value
  end

  def ctf_has_started?
    return render 'shared/countdown' if ctf_started? && !current_user&.organizer?
  end

  def ctf_started?
    Time.zone.now.to_f > CtfSetting.find_by(key: 'start_time').to_f
  end
end
