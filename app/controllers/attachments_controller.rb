class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def create
    message = {}
    @task = Task.find_by_id(params[:task_id])
    @attachment = @task.attachments.build(attachment_params)
    @attachment.user_id = current_user.id
    if @attachment.save
      cb = lambda { |envelope| puts envelope.message }
      begin
        message['message'] = 'added new Attachment'
        message['action'] = 'attachment_notification'
        message['id'] = @attachment.task_id
        pb = process_flow.publish({
                                      :channel => "channel_#{@attachment.task.project_id}",
                                      :message => message.to_json,
                                      :callback => cb
                                  })
      rescue
        puts "Error Exception"
      end
      respond_to do |format|
        format.js { render :layout => false }
      end
    end
  end

  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url, notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def download
    @attachment = Attachment.find(params[:id])
    send_file(@attachment.file.path)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attachment_params
    params.require(:attachment).permit(:file, :task_id)
  end
end
