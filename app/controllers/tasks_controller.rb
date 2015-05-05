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
    user_image = '';
    @project = Project.find_by_id(params[:project_id])
    @task = @project.tasks.build(task_params)
    @task.status_id = 1 #default status to backlog
    @task.last_updated_by = current_user.id
    cb = lambda { |envelope| puts envelope.message }
    @task.save
    if (params[:assigned].present?)
      user = User.find_by_id(params[:assigned])
      user.tasks << @task
      user_image = user.image_url.present? ? user.image_url : '/assets/default_user_icon.png'
    end
    begin
      message['message'] = 'added new task'
      message['title'] = @task.title
      message['task_type'] = @task.task_type
      message['project_id'] = @task.project_id
      message['action'] = 'create'
      message['id'] = @task.id
      message['effort'] = @task.effort
      message['priority'] = @task.priority.downcase
      message['end_date'] = @task.end_date.strftime('%d/%m/%Y') if @task.end_date.present?
      message['day_remaining_status'] = day_remaining_status(@task)
      message['assign_member'] = user_image
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
    UserSubcription.delete_all(user_id: current_user.id,task_id: @task.id)
    respond_to do |format|
      format.html {}
      format.js { render :layout => false }
    end
  end

  def update
    message = {}
    @project = current_user.projects.find_by_id(params[:project_id])
    @task = @project.tasks.find_by_id(params[:id])
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
      if @task.update_attributes(params[:field] => params[:value], :last_updated_by => current_user.id)
        message['message'] = @task.histories.last().context if @task.histories.present?
        message['field'] = params[:field]
        message['value'] = params[:value]
        message['action'] = 'update'
        message['remaining_status'] = day_remaining_status(@task)
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
    message = {}
    @user = User.find_by_id(params[:user_id])
    @task = Task.find_by_id(params[:id])
    @user.tasks << @task
    @user.save
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
        message['message'] = 'Assign new member'
        message['value'] = @user.image_url(:small_thumb).present? ? @user.image_url(:small_thumb) : '/assets/default_user_icon.png'
        message['action'] = 'assign_member'
        message['user_id'] = @user.id
        message['user_name'] = @user.name
        message['task_id'] = @task.id
        message['project_id'] = @task.project_id
        pb = process_flow.publish({
                                      :channel => "channel_#{@task.project_id}",
                                      :message => message.to_json,
                                      :callback => cb
                                  })
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
    @notifications = History.notification(@project_id, current_user.id).limit(15).offset(@count)
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def destroy
    message = {}
    cb = lambda { |envelope| puts envelope.message }
    @task_id = params[:id]
    project_id = params[:project_id]
    project = current_user.projects.find_by_id(project_id)
    if project.present?
      task = Task.find_by_id(@task_id)
      message['message'] = "<b> #{task.title} </b> has been removed"
      message['action'] = 'remove'
      message['task_id'] = task.id
      message['project_id'] = task.project_id
      message['time_ago'] = 'less then few seconds '
      if task.destroy
        pb = process_flow.publish({
                                      :channel => "channel_#{project_id}",
                                      :message => message.to_json,
                                      :callback => cb
                                  })
      end
    else
      flash[:error] = 'Internal error'
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update_position
    task_ids = params[:task]
    task_ids.each_with_index do |id, index|
      task = Task.find_by_id(id)
      task.update_attribute :position, index
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def destroy_notification_subcription
    project_id = params[:project_id]
    user_id = params[:user_id]
    NotificationSubcription.destroy_all(["project_id = ? and user_id = ?", project_id, user_id])
  end

  def import
    porject_id = params[:project_id]
    task = Task.import(params[:file], porject_id)
    if task != 0
      redirect_to dashboard_url(porject_id), notice: "Tasks are imported."
    else
      redirect_to dashboard_url(porject_id), notice: "Tasks are not imported. Unknown file type"
    end

  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :priority, :effort, :status_id, :end_date, :position, :relation, :project_id, :task_type)
  end

end
