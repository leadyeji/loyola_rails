class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :Customer, index: true
      t.belongs_to :Merchant, index: true
      t.float :amount

      t.timestamps
    end
  end
end
