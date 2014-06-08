class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :priority
      t.float :effort
      t.integer :status_id
      t.datetime :end_date
      t.integer :position
      t.integer :relation
      t.integer :project_id

      t.timestamps
    end
  end
end
