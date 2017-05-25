class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @product = Product.find(params[:product_id])
    @content = Message.new
  end

  def create
    @product = Product.find(params[:product_id])
    @content = Message.new(message_params)
    @content.product = @product
    @content.user = current_user

    if @content.save
      redirect_to product_path(@product)
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end


end
