class UsersController < ApplicationController
  before_filter :authorize_access, :validate_account, :except => [:cancel_reset_password, :reset_password, :reset_password_form, :index, :login, :send_login, :signup, :send_signup, :logout]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
        :redirect_to => { :action => :list }

  def list
    @users = User.find(:all)
  end
  
  def logout()
    session[:user_id] = nil
    redirect_to(:controller => 'users', :action => 'login')
  end
  
  def login()
    flash[:notice] = nil
    if (session[:user_id] != nil)
      redirect_to(:controller => 'projects')
    elsif (params[:email] && params[:password])
      found_user = User.authenticate(params[:email], params[:password])
      
      if (found_user)
        session[:user_id] = found_user.id
#        session[:account_id] = found_user.account_users.first().account_id
        redirect_to(:controller => 'projects')
      else
        flash[:notice] = "Either the username or password that you entered is incorrect."
      end
    end
  end

  def manage
    list
    if request.get? && params[:id].blank? #new
      @user = User.new
    elsif request.post? && params[:id].blank? #create
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = 'User was successfully created.'
        redirect_to :action => 'list'
      else
        render :action => 'manage'
      end
    elsif request.get? && !params[:id].blank? #edit
      @user = User.find(params[:id])
    elsif request.post? && !params[:id].blank? #update or delete
      if params[:commit] == 'Edit'
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
          flash[:notice] = 'User was successfully updated.'
          redirect_to :action => 'list'
        else
          render :action => 'manage'
        end
      else # action should delete
        User.find(params[:id]).destroy
        flash[:notice] = 'User was successfully deleted.'
        redirect_to :action => 'list'
      end
    end
  end

end
