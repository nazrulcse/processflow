module ProjectsHelper

  def project_statistic(project)
    tasks = project.tasks
    return [tasks.backlog.count, tasks.todo.count, tasks.doing.count, tasks.finish.count, tasks.done.count]
  end

  def task_history(statistics)
    data = {
        :backlog => [],
        :todo => [],
        :doing => [],
        :resolved => [],
        :done => [],
        :labels => []
    }

    statistics.each_with_index do |statistic, index|
      stats_data = statistic.date.strftime('%d')
      record = statistic.statistics
      data[:labels][index] = stats_data.to_i
      data[:backlog][index] = record[1]
      data[:todo][index] = record[2]
      data[:doing][index] = record[3]
      data[:resolved][index] = record[4]
      data[:done][index] = record[5]
    end
    return data
  end

end
