class TasksController < ApplicationController

  def new
     @project = Project.find_by_id(params[:project_id])
     @task = @project.tasks.build()
     respond_to do |format|
       format.html{render layout: false}
     end
  end

  def create
    @project = Project.find_by_id(params[:project_id])
    @task = @project.tasks.build(task_params)
    @task.status_id = 1 #default status to backlog
    @task.save
    respond_to do |format|
      format.js{render :layout => false}
    end
  end

  def show
   respond_to do |format|
     format.html{render :layout => false}
   end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :priority, :effort, :status_id, :end_date, :position, :relation, :project_id)
  end

end
