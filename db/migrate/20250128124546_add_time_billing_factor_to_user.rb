class AddTimeBillingFactorToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :time_billing_factor_in_ct, :integer
  end
end
