class TasksController < ApplicationController

  def new
     render layout: false
  end

  def create
  end

  def show
   respond_to do |format|
     format.html{render :layout => false}
   end
  end

end
