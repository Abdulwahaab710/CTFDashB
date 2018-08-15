# frozen_string_literal: true

class ActivateChallengesJob < ApplicationJob
  queue_as :default

  def perform
    return unless Time.zone.now >= Time.zone.parse(CtfSetting.find_by(key: 'start_time').value)
    challenges = challenges_to_be_activated
    activate(challenges)
  end

  private

  def challenges_to_be_activated
    Challenge.where(default_activision: true)
  end

  def activate(challenges)
    challenges.each { |c| c.update(active: true) }
  end
end
