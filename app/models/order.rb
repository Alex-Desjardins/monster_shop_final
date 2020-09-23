class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :user

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']


  def discount_subtotal_of(item_id)
    item = Item.find(item_id)
    order_item = OrderItem.find_by(item_id: item_id)
    greatest_discount = item.greatest_discount(order_item.quantity)
    (order_item.quantity * item.price * ((100 - greatest_discount.percentage.to_f) / 100)).round(2) if !greatest_discount.nil?
  end

  def grand_total
    total = 0.0
    order_items.each do |order_item|
      if !Item.find(order_item.item_id).merchant.discounts.empty? && order_item.quantity >= Item.find(order_item.item_id).discount_minimum_amount
        total += discount_subtotal_of(order_item.item_id)
      else
        total = order_items.sum('price * quantity')
      end
    end
    total.round(2)
  end

  def count_of_items
    order_items.sum(:quantity)
  end

  def cancel
    update(status: 'cancelled')
    order_items.each do |order_item|
      order_item.update(fulfilled: false)
      order_item.item.update(inventory: order_item.item.inventory + order_item.quantity)
    end
  end

  def merchant_subtotal(merchant_id)
    order_items
      .joins("JOIN items ON order_items.item_id = items.id")
      .where("items.merchant_id = #{merchant_id}")
      .sum('order_items.price * order_items.quantity')
  end

  def merchant_quantity(merchant_id)
    order_items
      .joins("JOIN items ON order_items.item_id = items.id")
      .where("items.merchant_id = #{merchant_id}")
      .sum('order_items.quantity')
  end

  def is_packaged?
    update(status: 1) if order_items.distinct.pluck(:fulfilled) == [true]
  end

  def self.by_status
    order(:status)
  end
end
