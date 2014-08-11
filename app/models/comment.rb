class Comment < ActiveRecord::Base
  belongs_to :task
  has_many :histories
  has_many :replies, :class_name => 'Comment', :foreign_key => 'parent'
  belongs_to :parent_post, :class_name => 'Comment', :foreign_key => 'parent'

  before_create :create_history
  before_update :update_history
  before_destroy :destroy_history

  def create_history
    if (self.parent.present?)
      @comment = Comment.find_by_parent(self.parent)
      History.create(:task_id => self.task.id, :user_id => self.user_id, :context => "Added reply: #{self.comment} of Comment #{@comment.comment}")
    else
      History.create(:task_id => self.task.id, :user_id => self.user_id, :context => "Added new comment: #{self.comment}")
    end
  end

  def update_history
    @comment = Comment.find_by_id(self.id)
    History.create(:task_id => self.task.id, :user_id => self.user_id, :context => "Edit comment: #{@comment.comment}")
  end

  def destroy_history
    @comment = Comment.find_by_id(self.id)
    History.create(:task_id => self.task.id, :user_id => self.user_id, :context => "Destroy comment: #{@comment.comment}")
  end

end
