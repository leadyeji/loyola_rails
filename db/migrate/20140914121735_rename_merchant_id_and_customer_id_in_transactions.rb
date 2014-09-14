class RenameMerchantIdAndCustomerIdInTransactions < ActiveRecord::Migration
  def change
    rename_column :transactions, :Merchant_id, :merchant_id
    rename_column :transactions, :Customer_id, :customer_id
  end
end
