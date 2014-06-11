class Task < ActiveRecord::Base
  belongs_to :project

  scope :backlog, -> {where(status_id: 1)}
  scope :doing, -> {where(status_id: 2)}
  scope :finish, -> {where(status_id: 3)}
  scope :done, -> {where(status_id: 4)}

end
