class CardProductsController < ApplicationController
  def index
    @card_products = CardProduct.all
  end

  def show
    @card_products = CardProduct.find(params[:id])
  end
end
