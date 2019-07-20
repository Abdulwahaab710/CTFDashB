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
    return true unless start_time

    Time.zone.now.to_i > Time.zone.parse(start_time&.value).to_i
  end

  def start_time
    @start_time ||= CtfSetting.find_by(key: 'start_time')
  end
end
