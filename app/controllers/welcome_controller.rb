class WelcomeController < ApplicationController
  before_action :authenticate_user, :except => ['index']

  def index
    respond_to do |format|
      format.html{render :layout => 'home'}
    end
  end

  def dashboard
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html{}
    end
  end

end
