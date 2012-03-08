class ClientsController < ApplicationController

  #layout "a different layout"

  before_filter :authorize_access, :except => [:index, :login, :send_login]
  
  def index
    login
    render(:action => 'login')
  end

  def login
    #@user = User.new
  end
  
  def send_login
		found_user = User.authenticate(params[:username], params[:password])
		if found_user
			session[:user_id] = found_user.id
			flash[:notice] = "You are now logged in."
			redirect_to(:controller => 'projects', :action => 'show')
		else
			flash.now[:notice] = "Username/password combination incorrect."
			render(:action => 'login')
		end
  end

  def menu
    
  end

  def logout
		session[:user_id] = nil
		flash[:notice] = "You are now logged out."
		redirect_to(:action => 'login')
  end
end