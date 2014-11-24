class WelcomeController < ApplicationController
  before_action :authenticate_user, :only => ['dashboard']

  def index
    respond_to do |format|
      format.html { render :layout => 'home' }
    end
  end

  def dashboard
    @project = Project.find(params[:id])
    @notifications = History.notification(params[:id], current_user.id).limit(15)
    respond_to do |format|
      format.html {}
    end
  end

end
