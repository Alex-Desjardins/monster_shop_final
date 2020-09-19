class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Merchant.find(current_user.merchant_id).discounts
  end

  def new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    @discount = merchant.discounts.create(discount_params)
    if @discount.save
      flash[:success] = "Discount Successfully Created"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      flash[:success] = "Discount Successfully Updated"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @discount = Discount.find(params[:id]).destroy
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.permit(:percentage, :item_amount)
  end
end
