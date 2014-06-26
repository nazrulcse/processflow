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

  def rest_of_users(task_users, project_users)

    if (task_users.nil?)
      return project_users
    elsif (project_users.nil?)
      return task_users
    else
      return project_users - task_users
    end
  end


end
