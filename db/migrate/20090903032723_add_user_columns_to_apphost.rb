class AddUserColumnsToApphost < ActiveRecord::Migration
  def self.up
    add_column :apphosts, :user_name, :string
    add_column :apphosts, :password, :binary
    add_column :apphosts, :password_key, :binary
    add_column :apphosts, :password_iv, :binary
  end

  def self.down
    remove_column :apphosts, :password_iv
    remove_column :apphosts, :password_key
    remove_column :apphosts, :password
    remove_column :apphosts, :user_name
  end
end
