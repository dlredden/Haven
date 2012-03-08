class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
		t.column :username, :string,		:limit => 25, :default => "", :null => false
		t.column :hashed_password, :string, :limit => 40, :default => "", :null => false
		t.column :first_name, :string, 		:limit => 25, :default => "", :null => false
		t.column :last_name, :string, 		:limit => 40, :default => "", :null => false
		t.column :email, :string, 			:limit => 50, :default => "", :null => false
		t.column :display_name, :string, 	:limit => 25, :default => "", :null => false
		t.column :user_level, :integer, 		:limit => 3,  :default => 0,  :null => false
    end
    User.create(:username => 'admin', :hashed_password => 'odewebware', :first_name => 'Admin', :last_name => 'User', :email => 'greg@odeit.com', :display_name => 'Admin User', :user_level => 9)
  end

  def self.down
    drop_table :users
  end
end
