class Comment < ActiveRecord::Base
  belongs_to :task
  has_many :replies, :class_name => "Comment", :foreign_key => "parent"
  belongs_to :parent_post, :class_name => "Comment", :foreign_key => "parent"
end
