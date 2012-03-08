class Account < ActiveRecord::Base
	has_many :account_users, :dependent => :destroy
  has_many :users, :through => :account_users
	has_many :projects, :dependent => :destroy
	belongs_to :plan
	
	validates_presence_of(:name, :subdomain)
	validates_uniqueness_of(:subdomain, :message => "The subdomain <strong>{{value}}</strong> has already been reserved.", :case_sensitive => false)
  validates_length_of(:subdomain, :in => 1..15, :message => "The subdomain <strong>{{value}}</strong> must be between 1 and 15 characters long.")
  validates_format_of(:subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true)
  validates_exclusion_of(:subdomain, :in => %w( support blog www billing help api ), :message => "The subdomain <strong>{{value}}</strong> is reserved and unavailable.")
  
  def before_validation
    self.subdomain.downcase! if attribute_present?("subdomain")
  end
  
  def before_save
  end

  def before_destroy
    return false if self.id == 1
  end

	def next_bill_date
		date = Date.today
		if (self.billed_on_day < date.day)
			Date.new(date.year, date.month + 1, self.billed_on_day)
		else
			Date.new(date.year, date.month, self.billed_on_day)
		end
  end
end
