class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    total = 0.0
    @contents.each do |item_id, item_quantity|
      if !Item.find(item_id).merchant.discounts.empty? && item_quantity >= Item.find(item_id).discount_minimum_amount
        total += discount_subtotal_of(item_id)
      else
        total += subtotal_of(item_id)
      end
    end
    total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discount_subtotal_of(item_id)
    item = Item.find(item_id)
    greatest_discount = item.greatest_discount(count_of(item_id))
    @contents[item_id.to_s] * item.price * ((100 - greatest_discount.percentage.to_f) / 100) if !greatest_discount.nil?
  end
end
