class AddUserIdFieldToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :user_id, :integer
  end

  def down
    remove_column :projects, :user_id
  end
end
