# frozen_string_literal: true

# Teams controller
class TeamsController < ApplicationController
  skip_before_action :user_logged_in?, only: :show
  skip_before_action :ctf_has_started?
  skip_before_action :submission_closed?

  def new
    redirect_to current_user.team unless current_user.team.nil?
    @team = Team.new
  end

  def create
    return head 404 unless current_user.team.nil?
    @team = Team.new(team_params)
    return render :new unless @team.save
    add_team_member
    redirect_to @team
  end

  def show
    @team = Team.find_by(id: params[:id])
  end

  def join
    redirect_to current_user.team unless current_user.team.nil?
    @team = Team.new
  end

  def join_team
    @ctf = CtfSetting.find_by(key: 'team_size')
    @team = Team.find_by(invitation_token: invitation_token[:invitation_token])
    return render_join_team if @team.nil?
    return render_team_full unless team_full?
    return redirect_to @team if add_team_member
  end

  def withdraw
    return head :not_found if current_user.team.nil?
    return redirect_to join_team_path if current_user.update(team: nil)
  end

  private

  def render_join_team
    flash[:danger] = 'Invalid token'
    redirect_to action: 'join'
  end

  def add_team_member
    return nil unless @team&.id
    current_user.team = @team
    current_user.save!
  end

  def render_team_full
    flash[:danger] = "Team #{@team.name} is already full"
    redirect_to action: 'join'
  end

  def team_full?
    true if (@team.users.count + 1) <= @ctf.value.to_i
  end

  def team_params
    params.require(:team).permit(:name)
  end

  def invitation_token
    params.require(:team).permit(:invitation_token)
  end
end
