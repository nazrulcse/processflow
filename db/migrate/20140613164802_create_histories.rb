class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :task_id
      t.integer :user_id
      t.text :context

      t.timestamps
    end
  end
end
