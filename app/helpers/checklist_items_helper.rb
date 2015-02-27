module ChecklistItemsHelper
  def complete_checklist_items(checklist_id)
    checklist = Checklist.find_by_id(checklist_id)
    checklist.checklist_items.where(:is_complete => 1).count()
  end

  def total_checklist_items(checklist_id)
    checklist = Checklist.find_by_id(checklist_id)
    checklist.checklist_items.count()
  end

end
