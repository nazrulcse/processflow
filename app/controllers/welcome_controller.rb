class WelcomeController < ApplicationController
  before_action :authenticate_user, :except => ['index']

  def home

  end

  def dashboard
   @teams = Team.all
  end

end
