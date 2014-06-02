class WelcomeController < ApplicationController
  before_action :authenticate_user, :except => ['index' , 'register']

  def home

  end

  def dashboard
   @teams = Team.all
  end

  def register
    
  end

end
