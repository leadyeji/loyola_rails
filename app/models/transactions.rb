class Transactions < ActiveRecord::Base
  belongs_to :Customer
  belongs_to :Merchant
end
