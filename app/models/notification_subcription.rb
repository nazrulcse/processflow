class NotificationSubcription < ActiveRecord::Base
  belongs_to :history
  belongs_to :user

  scope :notification_count, -> (project_id, user_id) { where(project_id: project_id, user_id: user_id).size }

end
