class WelcomeController < ApplicationController
  before_action :authenticate_user, :except => ['index']

  def index
    respond_to do |format|
      format.html{render :layout => 'home'}
    end
  end

  private

  def resolve_layout
    case action_name
      when "index"
        "home"
      else
        "application"
    end
  end

end
