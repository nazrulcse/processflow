module ProjectsHelper
  def project_statistic(project)
    tasks = project.tasks
    return [tasks.backlog.count, tasks.todo.count, tasks.doing.count, tasks.finish.count, tasks.done.count]
  end
end
