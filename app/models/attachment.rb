class Attachment < ActiveRecord::Base
  belongs_to :task

  include Rails.application.routes.url_helpers
  mount_uploader :file, FileUploader

end
