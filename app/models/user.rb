class User < ActiveRecord::Base
	has_many :account_users, :dependent => :destroy
  has_many :accounts, :through => :account_users
  has_many :projects, :through => :active_files
  
	validates_presence_of :first_name, :last_name, :email, :password
  validates_confirmation_of :password
	validates_length_of :password, :minimum => 8
	validates_length_of :first_name, :within => 1..25
	validates_length_of :last_name, :within => 1..40
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
	attr_accessor :password
	attr_protected :hashed_password, :salt
  
  def before_create()
		self.salt = User.make_salt(self.email)
		self.hashed_password = User.hash_with_salt(@password, self.salt)
	end
  
	def before_update()
	  if (!@password.blank? && @password != "BLANK PASSWORD FOR UPDATE OF USER")
  		self.salt = User.make_salt(self.email) if self.salt.blank?
  		self.hashed_password = User.hash_with_salt(@password, self.salt)
	  end
	end
  
  def after_save()
    @password = nil
  end
  
  def before_destroy()
    # Don't destroy if this user belongs to more than one account
    return false if (self.account_users.size > 1)
  end
  
  # Returns the user's first name and last name joined with a space.
	def full_name()
	  # this is an inside comment
		self.first_name + " " + self.last_name
	end
	
	def self.authenticate(_email = "", _password = "")
    _user = self.find(:first, :conditions => ["email = ?", _email])
    return (_user && _user.authenticated?(_password)) ? _user : nil
  end
  
  def authenticated?(_password = "")
    self.hashed_password == User.hash_with_salt(_password, self.salt)
  end
  
  def self.generate_password()
    @chars =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten - ['o','O','0','1','l','i','I']
    (0..8).map{ @chars[rand(@chars.length)]  }.join
  end
  
	private #----------------
  
  def self.make_salt(_string)
	  return Digest::SHA1.hexdigest(_string.to_s + Time.now.to_s)
  end
	
  def self.hash_with_salt(_password, _salt)
    return Digest::SHA1.hexdigest("Put #{_salt} on the #{_password}")
  end
  
end
