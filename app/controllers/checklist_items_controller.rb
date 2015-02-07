class ChecklistItemsController < ApplicationController
  def create
    checklist = Checklist.find_by_id(params[:checklist_id])
    @checklist_item = checklist.checklist_items.build(checklist_item_params)
    respond_to do |format|
      @checklist_item.save()
      format.js{}
    end
  end

  def complete
    checklist = Checklist.find_by_id(params[:checklist_id])
    @check_list_item = checklist.checklist_items.find_by_id(params[:id])
    respond_to do |format|
      if @check_list_item.is_complete
        @check_list_item.is_complete = false
      else
        @check_list_item.is_complete = true
      end
      @check_list_item.save
      format.js{}
    end
  end

  def update

  end

  def destroy
    checklist = Checklist.find_by_id(params[:checklist_id])
    check_list_item = checklist.checklist_items.find_by_id(params[:id])
    respond_to do |format|
      check_list_item.destroy
      format.js{}
    end
  end

  private

  def checklist_item_params
    params[:checklist_item].permit!
  end

end
