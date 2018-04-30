class SubmissionsController < ApplicationController
  include Submissions
  def create
    puts 'hello'
    @challenge = Challenge.find_by(flag: hash_flag(params[:flag]))
    if @challenge
      @submission = Submission.create(
        user: current_user,
        team: current_user.team,
        challenge: params[:challenge_id],
      )
    else
      flash[:error] = 'Invalid flag'
    end
  end
end
