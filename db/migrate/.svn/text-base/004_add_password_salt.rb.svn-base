class AddPasswordSalt < ActiveRecord::Migration
  def self.up
    add_column :users, :salt, :string, :limit => 40
    users = User.find(:all)
    users.each do |user|
      user.password = user.hashed_password
      user.save
    end
  end

  def self.down
    remove_column :users, :salt
    # this is a good candidate for an IrreversibleMigrationError
  end
end