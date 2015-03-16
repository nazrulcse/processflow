class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :parent
      t.integer :child
      t.string :description
      t.integer :project_id

      t.timestamps
    end
  end
end
