# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_current_account

  # Pick a unique cookie name to distinguish our session data from others'
  session = {:key => "_wikid_labs_haven_"}
  #session :disabled => true
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4e9e0620fb6436e526ef084407c242e3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  private #------------
	
	def authorize_access
	  if !session[:user_id]
	    flash[:notice] = "Please log in."
	    redirect_to(:controller => 'login')
	    return false
	  end	
	end
  
  def set_current_account
    #@current_account ||= Account.find_by_subdomain!((current_subdomain == nil) ? "odeubu1" : current_subdomain)
    @current_account ||= Account.find_by_subdomain!(current_subdomain)
  end
	
	def current_user
	  session[:user_id]
	end
	
	helper_method :current_user
end
