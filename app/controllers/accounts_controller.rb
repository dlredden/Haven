class AccountsController < ApplicationController
	before_filter :authorize_access

  LabelValue = Struct.new(:id,:value)
  
	def index
		show
	end

	def show
		@account = Account.find(params[:id])
  end

  def new
    build_cc_dropdown_arrays() 
    @account = Account.new
		@user = User.new
    @account.plan_id = 2
	end

	def create
		@account = Account.new(params[:account])
		@user = @account.users.build(params[:user])
    
    @user.display_name = @user.first_name + " " + @user.last_name
    @user.user_level = 9
    
    if (@account.save())
			redirect_to(:action => "index")
    else
      build_cc_dropdown_arrays() 
			render(:action => "new")
    end
  end

  private # Everything below this line is private
  
  def build_cc_dropdown_arrays
    @ccmonths = Selectvalue.find(:all, :conditions => [ "`key` = ?", "ccmonthdropdown"])
    @yearsArray = (Date.today.year..Date.today.year + 15).entries #(2009..2024).entries
    @yearsCollection = @yearsArray.collect {|yr| LabelValue.new(yr,yr)}
  end
end
