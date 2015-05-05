class CreateUserSubcriptions < ActiveRecord::Migration
  def change
    create_table :user_subcriptions do |t|
      t.integer :task_id
      t.integer :user_id
      t.timestamps
    end
  end
end
