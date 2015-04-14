class ChecklistsController < ApplicationController
  def create
    message = {}
     @checklist = Checklist.create(checklist_params)
    cb = lambda { |envelope| puts envelope.message }
     respond_to do |format|
       begin
         message['message'] = 'Add New Checklist'
         message['id'] = @checklist.id
         message['title'] = @checklist.title
         message['task_id'] = @checklist.task_id
         message['action'] = 'chk_list_create'
         pb = process_flow.publish({
                                       :channel => "channel_#{@checklist.task.project_id}",
                                       :message => message.to_json,
                                       :callback => cb
                                   })
       rescue Exception => e
         puts e.backtrace.inspect
       end
       format.js {}
     end
  end

  def update
    message = {}
    @checklist = Checklist.find_by_id(params[:id])
    @checklist.update_attributes(update_params)
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
      begin
        message['message'] = 'Update Checklist'
        message['id'] = @checklist.id
        message['title'] = @checklist.title
        message['task_id'] = @checklist.task_id
        message['action'] = 'chk_list_edit'
        pb = process_flow.publish({
                                      :channel => "channel_#{@checklist.task.project_id}",
                                      :message => message.to_json,
                                      :callback => cb
                                  })
      rescue Exception => e
        puts e.backtrace.inspect
      end
      format.js {}
    end
  end

  def destroy
    message = {}
    task = Task.find_by_id(params[:task_id])
    checklist = task.checklists.find_by_id(params[:id])
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
      checklist.destroy
      begin
        message['message'] = 'Remove Checklist'
        message['id'] = checklist.id
        message['title'] = checklist.title
        message['task_id'] = checklist.task_id
        message['action'] = 'chk_list_remove'
        pb = process_flow.publish({
                                      :channel => "channel_#{checklist.task.project_id}",
                                      :message => message.to_json,
                                      :callback => cb
                                  })
      rescue Exception => e
        puts e.backtrace.inspect
      end
      format.js{}
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
