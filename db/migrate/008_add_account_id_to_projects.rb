class AddAccountIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :account_id, :integer
  end

  def self.down
    remove_column :projects, :account_id
  end
end
