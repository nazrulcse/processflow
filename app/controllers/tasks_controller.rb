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
    @task.save
  end

  def show
   respond_to do |format|
     format.html{render :layout => false}
   end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :priority, :effort, :status_id, :end_Date, :position, :relation, :project_id)
  end

end
