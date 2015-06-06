class WelcomeController < ApplicationController
  before_action :authenticate_user, :only => ['dashboard', 'slug']

  def index
    respond_to do |format|
      if current_user.present?
        format.html {redirect_to projects_path}
      else
        format.html { render :layout => 'landing' }
      end
    end
  end

  def dashboard
    @project = Project.find(params[:id])
    @notifications = History.notification(params[:id], current_user.id).limit(15)
    respond_to do |format|
      format.html {}
    end
  end

  def slug
    task = Task.find_by_slug(params[:id])
    if task.present?
      redirect_to project_task_path(task.project_id, task.id)
    else
      flash[:error] = 'The card you are looking for is not exist'
      redirect_to projects_path
    end
  end

end
