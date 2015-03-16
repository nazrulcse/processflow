class ChecklistItemsController < ApplicationController
  def create
    message = {}
    checklist = Checklist.find_by_id(params[:checklist_id])
    @checklist_item = checklist.checklist_items.build(checklist_item_params)
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
      @checklist_item.save()

      begin
        message['message'] = 'added new Check List'
        message['id'] = @checklist_item.id
        message['title'] = @checklist_item.title
        message['checklist_id'] = @checklist_item.checklist_id
        message['is_complete'] =   false
        message['action'] = 'chk_create'
        message['time_ago'] = 'less then few seconds '
        pb = process_flow.publish({
                                      :channel => "channel_#{@checklist_item.checklist.task.project_id}",
                                      :message => message.to_json,
                                      :callback => cb
                                  })
      rescue
        puts "Error Exception"
      end
      format.js{}
    end
  end

  def complete
    message = {}
    @checklist = Checklist.find_by_id(params[:checklist_id])
    @check_list_item = @checklist.checklist_items.find_by_id(params[:id])
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
      if @check_list_item.is_complete
        @check_list_item.is_complete = false
      else
        @check_list_item.is_complete = true
      end
      @check_list_item.save
      begin
        message['message'] = 'complete task list'
        message['id'] = @check_list_item.id
        message['checklist_id'] = @check_list_item.checklist_id
        message['action'] = 'chk_list_comp'
        message['is_complete'] =   @check_list_item.is_complete
        pb = process_flow.publish({
                                      :channel => "channel_#{@check_list_item.checklist.task.project_id}",
                                      :message => message.to_json,
                                      :callback => cb
                                  })
      rescue Exception => e
        puts e.backtrace.inspect
      end
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
    message = {}
    @checklist = Checklist.find_by_id(params[:checklist_id])
    check_list_item = @checklist.checklist_items.find_by_id(params[:id])
    cb = lambda { |envelope| puts envelope.message }
    respond_to do |format|
      check_list_item.destroy
      begin
        message['message'] = 'Destroy task list'
        message['id'] = check_list_item.id
        message['checklist_id'] = check_list_item.checklist_id
        message['action'] = 'chk_list_dest'
        pb = process_flow.publish({
                                      :channel => "channel_#{check_list_item.checklist.task.project_id}",
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

  def checklist_item_params
    params[:checklist_item].permit!
  end

end
