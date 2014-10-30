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

  def is_image?(file)
    file_type = file.content_type
    if(file_type == 'image/png' || file_type == 'image/jpeg' || file_type == 'image/gif' || file_type == 'image/jpg')
      return true
    else
      return false
    end
  end

  def day_remaining_status(task)
    if(task.end_date?)
      today_time = Date.parse(task.end_date.to_s).to_time.to_i
      end_time = Date.today.to_time.to_i
      remaining_day = (today_time - end_time).to_i / 86400
      if(remaining_day == 2)
        return 'finish_tomorrow'
      elsif(remaining_day == 1)
        return 'finish_today'
      elsif(remaining_day <= 0)
        return 'time_past'
      else
        return ''
      end
    end
  end

end
