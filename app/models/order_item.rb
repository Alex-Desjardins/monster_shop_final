class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    quantity * price
  end

  def discount_subtotal_of(order_item)
    item = Item.find(order_item.item_id)
    greatest_discount = item.greatest_discount(order_item.quantity)
    (order_item.quantity * item.price * ((100 - greatest_discount.percentage.to_f) / 100)).round(2) if !greatest_discount.nil?
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end

  def find_item(order_item_id)
    Item.find(order_item_id)
  end
end
