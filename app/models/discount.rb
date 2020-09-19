class Discount < ApplicationRecord
 belongs_to :merchant

 validates_presence_of :percentage, :item_amount
 validates_numericality_of :percentage, greater_than_or_equal_to: 1, less_than_or_equal_to: 100
 validates_numericality_of :item_amount, greater_than: 0
end
