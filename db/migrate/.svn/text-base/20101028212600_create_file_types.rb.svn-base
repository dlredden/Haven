class CreateFileTypes < ActiveRecord::Migration
  def self.up
    create_table :file_types do |t|
      t.string :extention
      t.string :type
      t.string :image

      t.timestamps
    end
  end

  def self.down
    drop_table :file_types
  end
end
