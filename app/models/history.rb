class History < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  scope :notification, -> (project_id) { joins("INNER JOIN tasks ON tasks.id = histories.task_id " +
                                                   "INNER JOIN projects ON projects.id = tasks.project_id where tasks.project_id = #{project_id}") }
end
