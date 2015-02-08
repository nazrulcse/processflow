class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.date :date
      t.text :statistics
      t.string :statistics_type
      t.integer :project_id

      t.timestamps
    end
  end
end
