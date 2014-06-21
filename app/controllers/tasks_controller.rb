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
    @project = Project.find_by_id(params[:project_id])
    @task = @project.tasks.find_by_id(params[:id])
    @attachment = @task.attachments.build();
    @comments = @task.comments.where('comments.parent IS NULL')
    respond_to do |format|
      format.html{render :layout => false}
    end
  end

  def update
    @project = current_user.projects.find_by_id(params[:project_id])
    @task = @project.tasks.find_by_id(params[:id])
    respond_to do |format|
      if(@task.update_attributes(params[:field] => params[:value]))
        format.js{render :layout => false}
      end
    end
  end

  def assign

    @user = User.find_by_id(params[:user_id])
    @task = Task.find_by_id(params[:id])

    @user.tasks << @task
    @user.save

    respond_to do |format|
      format.js{render :layout => false}
    end
  end

  def unassign
    @user = User.find_by_id(params[:user_id])

    if @user.present?
      task = @user.tasks.find_by_id(params[:id])
      @user.tasks.delete(task)
    end

    respond_to do |format|
      format.js{render :layout => false}
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :priority, :effort, :status_id, :end_date, :position, :relation, :project_id)
  end

end
