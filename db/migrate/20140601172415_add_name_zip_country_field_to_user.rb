class AddNameZipCountryFieldToUser < ActiveRecord::Migration
  def up
    add_column :users, :name, :string
    add_column :users, :zip, :integer
    add_column :users, :country, :string
    add_column :users, :image, :string
  end
end
