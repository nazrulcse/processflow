class History < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  has_many :notification_subcriptions
  after_create :create_notification_subcription
  scope :notification, -> (project_id, user_id) { joins("INNER JOIN tasks ON tasks.id = histories.task_id " +
                                                   "INNER JOIN projects ON projects.id = tasks.project_id
                                                    where tasks.project_id = #{project_id} order by histories.created_at DESC") }
  scope :feeds, -> (user_id, offset_no) { joins("INNER JOIN tasks ON tasks.id = histories.task_id " +
                                                    "INNER JOIN projects ON projects.id = tasks.project_id INNER JOIN projects_users ON projects_users.project_id = projects.id where projects_users.user_id = #{user_id} order by histories.created_at DESC limit #{offset_no}, 10") }

  def create_notification_subcription
    user_ids = self.task.project.users
    project_id = self.task.project_id
    user_ids.each do |user_id|
      NotificationSubcription.create(:project_id => project_id, :user_id => user_id.id, :history_id => self.id)
    end
  end
end