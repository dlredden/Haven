class ProjectsController < ApplicationController
#  require "ftools"
  layout "project"
  before_filter :authorize_access
  
  verify :method => :post, :only => [ :destroy, :create, :update ], :redirect_to => { :action => :show }
  
  def index()
    redirect_to(:controller => 'dashboard')
  end
  
  def show()
    @projects = @current_account.projects
    
    if (params[:id] == nil)
      @current_project = projects[0]
    else
      @current_project = @current_account.projects.find(params[:id])
    end
    
    @current_user = AccountUser.find(current_user())
    @active_files = @current_user.get_active_files_by_project(@current_project.id)
    @project_tree_data = @current_project.get_directory_contents(@current_project.root_path, 0)
  end
  
  def new
    @hosttranstypes = Selectvalue.find_all_by_key("hosttranstypes")
    @project = Project.new
    @apphostdev = Apphost.new
    @repo = Repo.new
    @repo_types = RepoType.find_by_active(true)
  end
  
  def create
    @project = Project.new(params[:project])
    @apphostdev = @project.build_apphostdev(params[:apphostdev])
    @repo = @project.build_repo(params[:repo])
    if (@project.save)
      flash[:notice] = 'Project was successfully created.'
      @projects = @current_account.projects
      @current_project = @project
      
      render :update do |page|
        page.replace_html("project_view", :partial=>"projects/project", :locals => {:projects => @projects, :current_project => @current_project})
      end
    else
#       render :action => 'manage'
      flash[:notice] = 'Project was not created.'
    end
  end
  
  def change_project()
    @current_project = Project.find(params[:id])
    @project_tree_data = @current_project.get_directory_contents(@current_project.path, 0)
  end
  
  def edit
    render :update do |page|
      page.replace_html("project_name", :partial => "projects/edit_project", :id => params[:id])
    end
  end
  
  def manage
    if (request.get? && params[:id].blank?) #new
      @project = Project.new
      @apphostdev = Apphost.new
      @repo = Repo.new
    elsif (request.post? && params[:id].blank?) #create
      @project = Project.new(params[:project])
	    @apphostdev = @project.build_apphostdev(params[:apphostdev])
	    @repo = @project.build_repo(params[:repo])
      if (@project.save)
        flash[:notice] = 'Project was successfully created.'
        @projects = @current_account.projects
        @current_project = @project
        
        render :update do |page|
          page.replace_html("project_view", :partial=>"projects/project", :locals => {:projects => @projects, :current_project => @current_project})
        end
      else
#       render :action => 'manage'
        flash[:notice] = 'Project was not created.'
      end
    elsif request.get? && !params[:id].blank? #edit
      @project = Project.find(params[:id], :include => [:repo, :apphostdev])
    elsif request.post? && !params[:id].blank? #update or delete
      if params[:editorId]
        @project = Project.find(params[:id])
        @new_name = ""
        @new_name = params[:value] if params[:value]
        @project.name = @new_name
        @project.apphostdev.attributes = params[:apphostdev]
        @project.repo.attributes = params[:repo]
        if (@project.save)
          flash[:notice] = 'User was successfully updated.'
          @projects = @current_account.projects
          @current_project = @project
          
          render :update do |page|
            page.replace_html("project_view", :partial=>"projects/project", :locals => {:projects => @projects, :current_project => @current_project})
          end
        else
#         render :action => 'manage'
          flash[:notice] = 'Project was not updated.'
        end
      else # action should delete
        Project.find(params[:id]).destroy
        flash[:notice] = 'Project was successfully deleted.'
        @projects = @current_account.projects
        @current_project = @projects[0]
        
        render :update do |page|
          page.replace_html("project_view", :partial=>"projects/project", :locals => {:projects => @projects, :current_project => @current_project})
        end
      end
    end
  end

end
