# frozen_string_literal: true

class ScoresChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'scores_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
