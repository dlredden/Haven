class CreateRepos < ActiveRecord::Migration
  def self.up
    create_table :repos do |t|
		  t.column :url, :string,		:limit => 255, :default => "", :null => false
		  t.column :username, :string,		:limit => 25, :default => "", :null => false
		  t.column :password, :string,		:limit => 40, :default => "", :null => false
		  t.column :project_id, :integer, 		:limit => 11, :null => false
	  end
  end

  def self.down
    drop_table :repos
  end
end