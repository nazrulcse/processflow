class Checklist < ActiveRecord::Base
  belongs_to :task
  has_many :checklist_items
  accepts_nested_attributes_for :checklist_items, reject_if: proc { |attributes| attributes['title'].blank? }
end
