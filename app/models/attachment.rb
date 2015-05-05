class Attachment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  include Rails.application.routes.url_helpers
  mount_uploader :file, FileUploader
  after_create :create_history
  after_create :create_user_subcription
  def create_history
      History.create(:task_id => self.task_id, :user_id => self.task.last_updated_by, :context => "Added new Attachment")
  end

  def create_user_subcription
    user_ids = self.task.project.users.collect { |user| user.id } - Array.wrap(self.user_id)
    # user_ids.delete(self.user_id)
    task_id = self.task.id
    user_ids.each do |user_id|
      UserSubcription.create(:task_id => task_id, :user_id => user_id)
    end
  end

end
