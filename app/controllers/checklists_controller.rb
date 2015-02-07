class ChecklistsController < ApplicationController
  def create
     @checklist = Checklist.create(checklist_params)
     respond_to do |format|
       format.js {}
     end
  end

  def update
    @checklist = Checklist.find_by_id(params[:id])
    @checklist.update_attributes(update_params)
    respond_to do |format|
      format.js {}
    end
  end

  private

  def checklist_params
    params.permit(:task_id, :title)
  end

  def update_params
    params[:checklist].permit!
  end
end
