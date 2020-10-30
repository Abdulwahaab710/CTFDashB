# frozen_string_literal: true

module CtfSettings
  SUBMISSION_CONTROLLERS = [
    "submissions#create",
    "general_submissions#create"
  ]

  def ctf_name
    @ctf_name ||= CtfSetting.find_by(key: 'ctf_name')&.value
  end

  def ctf_has_started?
    return if SUBMISSION_CONTROLLERS.include?("#{controller_name}##{action_name}") && current_user&.organizer?
    return render 'shared/countdown' unless ctf_started?
  end

  def submission_closed?
    return render 'shared/submission_ended' if ctf_ended?
  end

  def ctf_started?
    return true unless start_time

    Time.zone.now.to_i > start_time.to_i
  end

  def ctf_ended?
    return false unless end_time

    Time.zone.now.to_i > end_time.to_i
  end

  def start_time
    @start_time ||= CtfSetting.start_time
  end

  def end_time
    @end_time ||= CtfSetting.end_time
  end
end
