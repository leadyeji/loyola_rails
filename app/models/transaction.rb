class Transaction < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
end
