class AddPaymentInfoToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :plan_id, :integer
    add_column :accounts, :payment_profile_id, :string
    add_column :accounts, :cc_last_four_digits, :integer
    add_column :accounts, :cc_exp_date, :date
    add_column :accounts, :cc_name, :string
    add_column :accounts, :bill_date, :date
  end

  def self.down
    add_column :accounts, :plan_id
    add_column :accounts, :payment_profile_id
    add_column :accounts, :cc_last_four_digits
    add_column :accounts, :cc_exp_date
    add_column :accounts, :cc_name
    add_column :accounts, :bill_date
  end
end
