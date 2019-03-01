# frozen_string_literal: true

module Admin
  class ChallengesController < AdminController
    before_action :fetch_categories

    include CtfSettings

    def index
      @challenges = Challenge.active
      @challenges = Challenge.all if current_user&.organizer?
      @team_submissions = team_submissions
    end

    def new
      @challenge = Challenge.new
      @category = Category.order(:name)
    end

    def create
      @challenge = Challenge.new(challenge_params)
      @challenge.challenge_files.attach(params[:challenge][:challenge_files]) if params[:challenge][:challenge_files]
      return redirect_to [@challenge.category, @challenge] if @challenge.save

      render :new, status: :unprocessable_entity
    end

    def edit
      @challenge = challenge
    end

    def update
      @challenge = challenge
      @challenge.challenge_files.attach(params[:challenge][:challenge_files]) if params[:challenge][:challenge_files]
      return render :edit unless @challenge.update(challenge_params_without_flag)

      redirect_to [@challenge.category, @challenge]
    end

    def update_flag
      @challenge = challenge
      render :edit unless @challenge.update(flag: BCrypt::Password.create(new_flag))
      flash[:success] = 'You have successfully updated the challenge flag'
      redirect_to [@challenge.category, @challenge]
    end

    def show
      @challenge_submission = Submission.new
      @challenge = challenge
      @challenge_submissions = @challenge.submissions.where(valid_submission: true)
      @team_submissions = Submission.where(team: current_user&.team).group(:challenge_id).count
    end

    def destroy
      challenge&.destroy
    end

    def activate
      @challenge = challenge
      @challenge.active = true
      redirect_to action: :index if @challenge.save!
    end

    def deactivate
      @challenge = challenge
      @challenge.active = false
      redirect_to action: :index if @challenge.save!
    end

    private

    def challenge
      @challenge ||= Category.find_by!(id: params[:category_id]).challenges.find_by!(id: params[:id])
    end

    def fetch_categories
      @categories = Category.all
    end

    def team_submissions
      Submission.where(team: current_user&.team).group(:challenge_id).count
    end

    def new_flag
      params[:challenge][:flag]
    end

    def challenge_params
      params.require(:challenge).permit(
        :title,
        :description,
        :link,
        :points,
        :flag,
        :max_tries,
        :active,
        :after_message,
        :category_id
      )
    end

    def challenge_params_without_flag
      params.require(:challenge).permit(
        :title,
        :description,
        :link,
        :points,
        :max_tries,
        :active,
        :after_message,
        :category_id
      )
    end
  end
end
