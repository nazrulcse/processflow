class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :title
      t.integer :task_id

      t.timestamps
    end
  end
end
