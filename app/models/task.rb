class Task < ActiveRecord::Base
  belongs_to :project
  has_many :attachments
  has_many :histories
  has_many :checklists
  belongs_to :status #, :foreign_key => :status_id
  has_and_belongs_to_many :users

  BACKLOG = 1
  TODO = 2
  DOING = 3
  RESOLVED = 4
  DONE = 5

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



  def self.import(file,project_id)
    project = Project.find_by_id(project_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    header.each_with_index do |h, i|
      # if !(('title' == h) or ('description' == h )or ('priority' == h ))
      #   header.delete(h)
      # end
    end
    task = project.tasks.build();
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      unless row['title'].blank?
        task.title = row['title']
      end
      unless row['description'].blank?
        task.description = row['description']
      end
      unless row['priority'].blank?
        task.priority = row['priority']
      end
      unless row['status_id'].blank?
        task.status_id = row['status_id']
      end
      # unless row[:title].blank?
      #   task.title = row[:title]
      # end
      # unless row[:title].blank?
      #   task.title = row[:title]
      # end
      # unless row[:title].blank?
      #   task.title = row[:title]
      # end
      # task = project.tasks.build(row.to_hash.slice(*row.to_hash.keys))
      task.last_updated_by = project.owner_id
      task.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
      when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
      when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end




end
