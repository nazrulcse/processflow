class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]

  def create
    @comment = Comment.new(comment: params[:comment], task_id: params[:task_id], user_id: current_user.id, parent: params[:parent])
    respond_to do |format|
      if @comment.save
        format.js { render :layout => false }
      end
    end
  end

  def update
    respond_to do |format|
      @comments = Comment.find_by_id(params[:id])
      if @comments.update_attributes(comment: params[:comment], task_id: params[:task_id], user_id: current_user.id, parent: @comments.parent)
        format.js { render :layout => false }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:comment, :task_id, :user_id, :parent)
  end

end
