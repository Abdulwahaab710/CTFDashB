# frozen_string_literal: true

class CtfSettingsController < ApplicationController
  before_action :user_logged_in?
  before_action :user_has_permission?

  include Users

  def edit
    settings_params.each do |param|
      setting = CtfSetting.find_or_create_by!(key: param[0])
      setting.update(value: param[1])
      schedule_job(job_class_and_time(params[1]))
    end
    flash[:success] = 'Settings has been updated'
    redirect_to action: 'show'
  end

  def show
    @ctf_settings = CtfSetting.all
  end

  private

  def job_class_and_time(key)
    return { active_job_class: ActivateChallengesJob, time: Time.zone.parse(key) } if key == 'start_time'
  end

  def settings_params
    params[:key].zip params[:value]
  end

  def schedule_job(active_job_class: nil, time: nil)
    active_job_class&.set(wait_until: time)&.perform_later(guest)
  end
end
