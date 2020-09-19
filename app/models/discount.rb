class Discount < ApplicationRecord
 belongs_to :merchant

 validates_presence_of :discount, :amount
 validates_numericality_of :discount, greater_than_or_equal_to: 1, less_than_or_equal_to: 100
 validates_numericality_of :amount, greater_than: 0
end
