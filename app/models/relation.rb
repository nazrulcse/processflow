class Relation < ActiveRecord::Base
  belongs_to :project

  def parent_task
    Task.find_by_id(self.parent)
  end

  def child_task
    Task.find_by_id(self.child)
  end
end
