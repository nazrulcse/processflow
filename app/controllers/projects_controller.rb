class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  def index
    @projects = current_user.projects.order('id DESC')
    @feeds = History.feeds(current_user.id,0)
  end

  def show
    @project = current_user.projects.find_by_id(params[:id])
    respond_to do |format|
      if (@project.present?)
        format.html { redirect_to dashboard_path() }
      else
        flash.keep[:error] = 'Access your requested project is denied'
        redirect_to projects_path()
      end
    end
  end

  def new
    @project = Project.new
    render :layout => false
  end

  def create
    @project = Project.new(project_params)
    @project.users << current_user
    respond_to do |format|
      if @project.save
        format.html { render :layout => false }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.js { }
      end
    end
  end

  def edit
    @project = current_user.projects.find_by_id(params[:id]);
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_feeds
    @feeds = History.feeds(current_user.id,5)
    puts"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
     puts(@feeds.inspect)
    puts"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  end

  private

  def set_project
    @project = Project.find_by_id(params[:id])
    if !@project.present?
      flash.keep[:notice] = 'Access your requested project is denied'
      redirect_to projects_path()
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :status).merge(owner_id: current_user.id)
  end

end
