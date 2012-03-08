class AddFileTypeIdToActiveFiles < ActiveRecord::Migration
  def self.up
    add_column :active_files, :file_type_id, :int
  end

  def self.down
    remove_column :active_files, :file_type_id
  end
end
