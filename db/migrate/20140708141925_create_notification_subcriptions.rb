class CreateNotificationSubcriptions < ActiveRecord::Migration
  def change
    create_table :notification_subcriptions do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :history_id

      t.timestamps
    end
  end
end
