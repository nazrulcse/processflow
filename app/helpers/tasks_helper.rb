module TasksHelper

  def remaining_effort(task)
    if(task.spend.nil?)
      return task.effort.to_f
    elsif(task.effort.nil?)
      return task.spend.to_f
    else
      return task.effort.to_f - task.spend.to_f
   end
  end

end
