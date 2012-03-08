class RepositoriesController < ApplicationController
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
         
  def checkout
    @project = Project.find(params[:repo][:project_id])
    @repo = @project.repo
    Rails.logger.info("repo: #{@repo.inspect}, repo_project: #{@project.inspect}")
    @vc_output = %x[svn co --username #{params[:repo][:username]} --password #{params[:repo][:password]} #{@repo.url} #{@project.local_path}]
    if @vc_output.blank?
      flash[:notice] = 'Import from repository failed.'
    else
      redirect_to :controller => 'filesystems', :action => 'build_tree', :project => @project
    end
  end
  
  def repo_credentials
    
  end
 
  def manage
    if request.get? && params[:id].blank? #new
      @repo = Repo.new
    elsif request.post? && params[:id].blank? #create
      Rails.logger.info("PARAMS: #{params.inspect}")
      @repo = Repo.new(params[:repo])
      if @repo.save
        redirect_to :action => 'checkout', :repo => @repo
      else
        flash[:notice] = 'Repository was not create.'
      end
    elsif request.get? && !params[:id].blank? #edit
      @repo = Repo.find(params[:id])
    elsif request.post? && !params[:id].blank? #update or delete
      if params[:commit] == 'Edit'
        @repo = Repo.find(params[:id])
        if @repo.update_attributes(params[:repo])
          flash[:notice] = 'Repository was successfully updated.'
        else
          flash[:notice] = 'Repository was not updated.'
        end
      else # action should delete
        Repo.find(params[:id]).destroy
        flash[:notice] = 'repo was successfully deleted.'
        redirect_to :action => 'list'
      end
    end
  end
  
  
end
