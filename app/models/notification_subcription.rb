class NotificationSubcription < ActiveRecord::Base
  belongs_to :history
  belongs_to :user

  scope :notification_count, -> (project_id, user_id) { where(project_id: project_id, user_id: user_id).size }
  scope :read_info,  -> (notification) {  where(history_id: notification.id, user_id: notification.user_id)}

end
