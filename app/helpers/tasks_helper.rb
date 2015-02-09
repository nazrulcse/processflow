module TasksHelper

  def remaining_effort(task)
    if (task.spend.nil?)
      return task.effort.to_f
    elsif (task.effort.nil?)
      return task.spend.to_f
    else
      return task.effort.to_f - task.spend.to_f
    end
  end

  def task_progress(task)
    effort = task.effort.nil? ? 0 : task.effort
    spend = task.spend.nil? ? 0 : task.spend
    if spend > effort
      return 100
    elsif effort == 0
      return 0
    else
      return (spend * 100 / effort)
    end
  end

  def rest_of_users(task_users, project_users)
    if (task_users.nil?)
      return project_users
    elsif (project_users.nil?)
      return task_users
    else
      return project_users - task_users
    end
  end

  def is_image?(file)
    file_type = file.content_type
    if(file_type == 'image/png' || file_type == 'image/jpeg' || file_type == 'image/gif' || file_type == 'image/jpg')
      return true
    else
      return false
    end
  end
end
