class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Merchant.find(current_user.merchant_id).discounts
  end
end
