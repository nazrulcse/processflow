class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :model
      t.integer :model_id
      t.string :action
      t.text :comments

      t.timestamps
    end
  end
end
