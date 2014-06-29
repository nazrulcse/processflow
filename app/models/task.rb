class Task < ActiveRecord::Base
  belongs_to :project
  has_many :attachments
  has_many :histories
  belongs_to :status #, :foreign_key => :status_id
  has_and_belongs_to_many :users

  after_create :create_history
  after_update :update_history

  has_many :comments
  scope :backlog, -> { where(status_id: 1) }
  scope :todo, -> { where(status_id: 2) }
  scope :doing, -> { where(status_id: 3) }
  scope :finish, -> { where(status_id: 4) }
  scope :done, -> { where(status_id: 5) }

  def create_history
    History.create(:task_id => self.id, :user_id => self.project.owner_id, :context => "Added new task: #{self.title}")
  end

  def update_history
    if (self.status_id_changed?)
      context = "Changed task status to: #{self.status.detail}"
    elsif (self.description_changed?)
      context = "Changed task description to: #{self.description}"
    elsif (self.priority_changed?)
      context = "Changed task priority to: #{self.priority}"
    end
    History.create(:task_id => self.id, :user_id => self.project.owner_id, :context => context)
  end

end
