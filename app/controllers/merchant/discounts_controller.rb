class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Merchant.find(current_user.merchant_id).discounts
  end

  def new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    merchant.discounts.create(discount_params)
    flash[:success] = "Discount Successfully Created"
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.permit(:percentage, :item_amount)
  end
end
