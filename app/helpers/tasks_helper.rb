module TasksHelper

  def remaining(task)
    if(task.spend.nil?)
      return task.effort
    elsif(task.effort.nil?)
      return task.spend
    else
      return task.effort - task.spend
   end
  end

end
