class AddActiveToPlans < ActiveRecord::Migration
  def self.up
	add_column :plans, :is_active, :boolean, :default => 1
  end

  def self.down
	remove_column :plans, :is_active
  end
end
