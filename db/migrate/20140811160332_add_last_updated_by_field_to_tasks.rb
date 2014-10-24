class AddLastUpdatedByFieldToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :last_updated_by, :string
  end
end
