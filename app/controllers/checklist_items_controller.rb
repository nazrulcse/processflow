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
    @checklist = Checklist.find_by_id(params[:checklist_id])
    @check_list_item = @checklist.checklist_items.find_by_id(params[:id])
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

  def count_item
       @checklist = Checklist.find_by_id(params[:id])
       @complete_item = @checklist.checklist_items.where(:is_complete => 1).count()
       @total_item = @checklist.checklist_items.count()
       @percent =  ( @complete_item.to_f  / @total_item) * 100
  end

  def update

  end

  def destroy
    @checklist = Checklist.find_by_id(params[:checklist_id])
    check_list_item = @checklist.checklist_items.find_by_id(params[:id])
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
