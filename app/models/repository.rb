class Repository < ActiveRecord::Base
  belongs_to :repository_type
  has_many :projects, :dependent => :destroy
  
  encrypt_with_public_key :username, :key_pair => File.join(RAILS_ROOT, "config","keypair.pem")
  encrypt_with_public_key :password, :key_pair => File.join(RAILS_ROOT, "config","keypair.pem")
  
  validates_confirmation_of :password
	validates_presence_of :address, :username, :password
  
  def repo_username()
    self.username.decrypt(SB_KEY)
  end
  
  def repo_password()
    self.password.decrypt(SB_KEY)
  end
end
