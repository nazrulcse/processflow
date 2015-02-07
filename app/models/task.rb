class Task < ActiveRecord::Base
  belongs_to :project
  has_many :attachments
  has_many :histories
  has_many :checklists
  belongs_to :status #, :foreign_key => :status_id
  has_and_belongs_to_many :users

  after_create :create_history
  after_update :update_history

  has_many :comments
  scope :backlog, -> { where(status_id: 1).order('position') }
  scope :todo, -> { where(status_id: 2).order('position') }
  scope :doing, -> { where(status_id: 3).order('position') }
  scope :finish, -> { where(status_id: 4).order('position') }
  scope :done, -> { where(status_id: 5).order('position') }

  def create_history
    if self.task_type == 'feature'
      History.create(:task_id => self.id, :user_id => self.last_updated_by, :context => "Added new task: #{self.title}")
    else
      History.create(:task_id => self.id, :user_id => self.last_updated_by, :context => "Added new Bug: #{self.title}")
    end
  end

  def update_history
    if (self.status_id_changed?)
      context = "Changed task status to: #{self.status.detail}"
    elsif (self.description_changed?)
      context = "Changed task description to: #{self.description}"
    elsif (self.priority_changed?)
      context = "Changed task priority to: #{self.priority}"
    elsif (self.effort_changed?)
      context = "Changed task effort to: #{self.effort}"
    elsif (self.spend_changed?)
      context = "Changed task spend to: #{self.spend}"
    elsif (self.end_date_changed?)
      context = "Changed task end date to: #{self.end_date}"
    elsif (self.title_changed?)
      context = "Changed task title to: #{self.title}"
    elsif (self.task_type_changed?)
      context = "Changed task type to: #{self.task_type}"
    end
    if context.present?
     History.create(:task_id => self.id, :user_id => self.last_updated_by, :context => context)
    end
  end

  scope :latest, -> (project_id, user_id) {
    joins("track ")
  }


end
