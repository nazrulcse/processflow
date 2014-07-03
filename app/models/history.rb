class History < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  scope :notification, -> (project_id) { joins("INNER JOIN tasks ON tasks.id = histories.task_id " +
                                                   "INNER JOIN projects ON projects.id = tasks.project_id where tasks.project_id = #{project_id} order by histories.created_at DESC") }
  scope :feeds, -> (user_id,offset_no) { joins("INNER JOIN tasks ON tasks.id = histories.task_id " +
                                         "INNER JOIN projects ON projects.id = tasks.project_id INNER JOIN projects_users ON projects_users.project_id = projects.id where projects_users.user_id = #{user_id} order by histories.created_at DESC limit #{offset_no}, 10") }
end
