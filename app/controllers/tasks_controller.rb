class TasksController < ApplicationController

  def new
    @project = Project.find_by_id(params[:project_id])
    @task = @project.tasks.build()
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def create
    message = {}
    @project = Project.find_by_id(params[:project_id])
    @task = @project.tasks.build(task_params)
    @task.status_id = 1 #default status to backlog
    cb = lambda { |envelope| puts envelope.message }
    @task.save
    begin
      message['message'] = 'added new task'
      message['title'] = @task.title
      message['project_id'] = @task.project_id
      message['action'] = 'create'
      message['id'] = @task.id
      message['effort'] = @task.effort
      message['priority'] = @task.priority.downcase
      message['end_date'] = @task.end_date.strftime('%d/%m/%Y') if @task.end_date.present?
      pb = process_flow.publish({
          :channel => "channel_#{@task.project_id}",
          :message => message.to_json,
          :callback => cb
      })
    rescue
      puts "Error Exception"
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def show
    @project = Project.find_by_id(params[:project_id])
    @task = @project.tasks.find_by_id(params[:id])
    @attachment = @task.attachments.build();
    @comments = @task.comments.where('comments.parent IS NULL')
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    message = {}
    @project = current_user.projects.find_by_id(params[:project_id])
    @task = @project.tasks.find_by_id(params[:id])
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
      if (@task.update_attributes(params[:field] => params[:value]))
        message['message'] = @task.histories.last().context if @task.histories.present?
        message['field'] = params[:field]
        message['value'] = params[:value]
        message['action'] = 'update'
        message['task_id'] = @task.id
        message['project_id'] = @task.project_id
        message['time_ago'] = 'less then few seconds '
        pb = process_flow.publish({
            :channel => "channel_#{@project.id}",
            :message => message.to_json,
            :callback => cb
        })
        format.js { render :layout => false }
      end
    end
  end

  def search_task
    @search_item = params[:search_item]
    @project_id = params[:project_id]
    if @search_item != Integer
      if @search_item.nil?
        @project = Project.find_by_id(@project_id)
        @task = @project.tasks
      else
        @task = Task.find_by_sql("select * from tasks where title like '%#{@search_item}%' and 	project_id = '#{@project_id}'")
      end

    else
      @task = Task.find_by_id(@search_item)
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def assign
    @user = User.find_by_id(params[:user_id])
    @task = Task.find_by_id(params[:id])
    @user.tasks << @task
    @user.save
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def unassign
    @user = User.find_by_id(params[:user_id])
    if @user.present?
      task = @user.tasks.find_by_id(params[:id])
      @user.tasks.delete(task)
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def get_notification
    @count = params[:count]
    @project_id = params[:project_id]
    @notifications = History.notification(@project_id).limit(15).offset(@count)
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def destroy_notification_subcription
    project_id = params[:project_id]
    user_id = params[:user_id]
    NotificationSubcription.destroy_all(["project_id = ? and user_id = ?",project_id,user_id])
  end

def destroy
  @task_id = params[:id]
  project_id = params[:project_id]
  project = current_user.projects.find_by_id(project_id)
  if(project.present?)
    task = Task.find_by_id(@task_id)
    task.destroy
  end
  respond_to do |format|
    format.js { render :layout => false }
  end
end


  private
  def task_params
    params.require(:task).permit(:title, :description, :priority, :effort, :status_id, :end_date, :position, :relation, :project_id, :task_type)
  end

end
