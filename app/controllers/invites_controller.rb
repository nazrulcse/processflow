class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  def new
    @invite = Invite.new
    render :layout => false
  end

  def create
    @user = User.find_by_email(params[:invite][:email])
    respond_to do |format|
      if (@user.present?)
        if (@user.projects.find_by_id(params[:project_id]).present?)
          @result = 'Already assigned'
        else
          @project = Project.find_by_id(params[:project_id])
          @project.users << @user
          @result = 'Successfully Assigned'
        end
      else
        if !Invite.where('email = ? AND project_id = ?', params[:invite][:email], params[:project_id]).present?
          @invite = Invite.new(invite_params)
          if @invite.save
            @invites = Invite.where('email = ? AND project_id = ?', @invite.email, @invite.project_id).first
            Invitation.invitation_email(@invites).deliver
            @result = 'Invitation was sent to user Email'
          end
        else
          @result = 'Already Assigned'
        end
      end
      format.js { render :layout => false }
    end
  end

  def accept_invitation
    @token = params[:token]
    @invites = Invite.find_by_token(@token)
    if !@invites.present?
      flash[:error] = 'Invalid Token'
    end
  end

  def user_create
    @token = params[:user][:token]
    @invites = Invite.find_by_token(@token)
    @user = User.new(name: params[:user][:name], email: @invites.email, password: params[:user][:password])
    @project = Project.find_by_id(@invites.project_id)
    @project.users << @user
    sign_in(@user)
    @invites.remove()
    redirect_to profile_path()
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_invite
    @invite = Invite.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invite_params
    # params[:invite]
    params.require(:invite).permit(:email,).merge(project_id: params[:project_id], exp_date: DateTime.now.tomorrow.to_date, token: @random_token)
  end
end
