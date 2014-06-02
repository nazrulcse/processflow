class WelcomeController < ApplicationController
  before_action :authenticate_user, :except => ['index']
  layout :resolve_layout

  def index

  end

  def dashboard
   @teams = Team.all
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
