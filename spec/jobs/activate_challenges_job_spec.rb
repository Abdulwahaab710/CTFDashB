# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivateChallengesJob, type: :job do
  describe '#perform_later' do
    before :each do
      FactoryBot.create(:challenge, active: false)
      FactoryBot.create(:start_time)
    end

    it 'queues the job' do
      ActiveJob::Base.queue_adapter = :test
      expect { ActivateChallengesJob.perform_later }.to have_enqueued_job
    end

    context 'when the start_time is less than or equal to the current time' do
      it 'activates all challenges' do
        expect { ActivateChallengesJob.perform_now }.to change { Challenge.where(active: true).count }.from(0).to(1)
      end
    end

    context 'when the start_time is greater than the current time' do
      before :each do
        CtfSetting.where(key: 'start_time').update(value: Time.zone.now + 2.hours)
      end

      it 'does not activate any challenges' do
        expect { ActivateChallengesJob.perform_now }.not_to change { Challenge.where(active: true).count }.from(0)
      end
    end
  end
end
