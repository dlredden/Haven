class ActiveFilesController < ApplicationController
  def show
    @current_project = Project.find(:first, :conditions => {:account_id => session[:account_id]})
    @current_user = User.find(session[:user_id])
  end
  
  def refresh_display
    User.find(session[:user_id]).cleanup_open_files()
    @fa_data = User.find(session[:user_id]).get_recent_files()
    
    render :update do |page|
      page << "buildYUITreeView('fileactivity_tree', #{@fa_data})"
    end
  end
  
  def create
    @file = File.find_or_create_by_user_id_and_project_id_and_full_file_name(session[:user_id], params[:project_id], params[:full_file_name])
    @file.file_name = params[:file_name]
    @file.touched_at = Time.now()
    
    if (@file.save())
      refresh_display()
    end
  end
  
  def open()
    
  end
end
