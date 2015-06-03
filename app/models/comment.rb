class Comment < ActiveRecord::Base
  belongs_to :task
  has_many :histories
  belongs_to :user
  has_many :replies, :class_name => 'Comment', :foreign_key => 'parent'
  belongs_to :parent_post, :class_name => 'Comment', :foreign_key => 'parent'

  before_create :create_history
  before_update :update_history
  before_destroy :destroy_history
  after_create :create_user_subcription

  def create_history
    if self.parent.present?
      comment = Comment.find_by_id(self.parent)
      History.create(:task_id => self.task.id, :user_id => self.user_id, :context => "Added reply: #{self.comment} of Comment #{comment.comment}")
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

  def create_user_subcription
    user_ids = self.task.project.users.collect { |user| user.id } - Array.wrap(self.user_id)
    # user_ids.delete(self.user_id)
    task_id = self.task.id
    user_ids.each do |user_id|
      UserSubcription.create(:task_id => task_id, :user_id => user_id)
    end
  end


end
