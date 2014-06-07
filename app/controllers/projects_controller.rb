class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  def index
    @projects = current_user.projects.order("id DESC")
  end

  def show
    @project = current_user.projects.find_by_id(params[:id])
    if(@project.present?)
      redirect_to dashboard_path()
    else
      flash.keep[:error] = 'Access your requested project is denied'
      redirect_to projects_path()
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
          format.html{render :layout => false}
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
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
