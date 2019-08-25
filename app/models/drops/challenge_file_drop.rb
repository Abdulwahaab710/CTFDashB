# frozen_string_literal: true

class ChallengeFileDrop < Liquid::Drop
  def initialize(challenge_file)
    @challenge_file = challenge_file
  end

  def filename
    @challenge_file&.filename&.to_s
  end

  def path
    Rails.application.routes.url_helpers.rails_blob_path(
      @challenge_file, disposition: 'attachment', only_path: true
    )
  end
end
