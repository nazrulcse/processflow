class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.js { render :layout => false }
      end
    end
  end

  def reply
    @task = Task.find_by_id(params[:task_id])
    @comment = @task.comments.build(:parent => params[:id])
    respond_to do |format|
      format.js{}
    end
  end

  def edit
    @task = Task.find_by_id(params[:task_id])
    @comment = Comment.find_by_id(params[:id])
    respond_to do |format|
      format.js{}
    end
  end

  def update
    respond_to do |format|
      @comments = Comment.find_by_id(params[:id])
      if @comments.update_attributes(comment_update_params)
        format.js { render :layout => false }
      end
    end
  end

  def new
    @task = Task.find_by_id(params[:task_id])
    @comment = @task.comments.build()
    respond_to do |format|
      format.js{}
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
    params.require(:comment).permit!.merge(:user_id => current_user.id)
  end

  def comment_update_params
    params.require(:comment).permit!
  end

end
