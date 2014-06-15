class AddSpendToTask < ActiveRecord::Migration
  def up
    add_column :tasks, :spend, :float
  end

  def down
    remove_column :tasks, :spend
  end
end
