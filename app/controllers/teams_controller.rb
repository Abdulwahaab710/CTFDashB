# Teams controller
class TeamsController < ApplicationController
  before_action :user_logged_in?

  def new
    redirect_to current_user.team unless current_user.team.nil?
    @team = Team.new
  end

  def create
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
    @ctf = CTFSetting.find_by(key: 'max_teammates')
    @team = Team.find_by(invitation_token: invitation_token)
    render_join_team
    return unless team_full?
    return redirect_to @team if add_team_member
    flash.now[:error] = 'Invalid token'
    render :join
  end

  private

  def render_join_team
    return nil unless @team&.id
    @team = Team.new
    flash.now[:error] = 'Invalid token'
    render :join
  end

  def add_team_member
    return nil unless @team&.id
    current_user.team = @team
    current_user.save!
  end

  def team_full?
    return true if (@team.users.count + 1) <= @ctf.value.to_i
    flash.now[:error] = "Team #{@team.name} is already full"
    render :join
  end

  def team_params
    params.require(:team).permit(:name)
  end

  def invitation_token
    params.require(:team).permit(:invitation_token)
  end
end
