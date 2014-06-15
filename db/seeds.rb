# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Status.create(:id => 1, :detail => "Project Backlog")
Status.create(:id => 2, :detail => "ToDo")
Status.create(:id => 3, :detail => "In Progress")
Status.create(:id => 4, :detail => "Finish")
Status.create(:id => 5, :detail => "Done")