class DashboardController < ApplicationController  
  layout "dashboard"
  
  def index()
    @projects = @current_account.projects
    respond_to do |format|
      format.html
    end
  end
end