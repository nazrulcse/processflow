class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.integer :project_id
      t.string :token
      t.date :exp_date
      t.timestamps
    end
  end
end
