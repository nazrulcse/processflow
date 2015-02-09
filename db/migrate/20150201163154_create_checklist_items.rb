class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.string :title
      t.integer :checklist_id
      t.boolean :is_complete

      t.timestamps
    end
  end
end
