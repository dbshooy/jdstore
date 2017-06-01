class ProductsController < ApplicationController

  before_action :validate_search_key, only: [:search]
  before_action :authenticate_user!, only: [:favorite]


  def index
    @products = case params[:order]
                when 'Tea'
                  Product.where(category: "Tea").recent.paginate(:page => params[:page], :per_page => 2)
                when 'Wine'
                  Product.where(category: "Wine").recent.paginate(:page => params[:page], :per_page => 2)
                when 'Fruit'
                  Product.where(category: "Fruit").recent.paginate(:page => params[:page], :per_page => 2)
                when 'Product'
                  Product.where(category: "Product").recent.paginate(:page => params[:page], :per_page => 2)
                else
                  Product.all.recent.paginate(:page => params[:page], :per_page => 2)
                end
  end

  def show
    @product = Product.find(params[:id])
    @messages = @product.messages
  end

  def add_to_cart
    @product = Product.find(params[:id])
    if !current_cart.products.include?(@product)
      current_cart.add_product_to_cart(@product)
      flash[:notice] = "你已成功将 #{@product.title} 加入购物车"
    else
      flash[:warning] = "你的购物车内已有此物品"
    end
    redirect_to :back
  end

  # favorite part(藏宝阁)

  def favorite
    @product = Product.find(params[:id])
    if !current_user.products.include?(@product)
      @favorite = Favorite.new
      @favorite.user = current_user
      @favorite.product = @product
      @favorite.save
      redirect_to :back
      flash[:notice] = "你添加了 #{@product.title}."
    else
      redirect_to :back
      flash[:warning] = "你不能重复进行此操作."
    end
  end

  def cancel_favorite
    @user = current_user
    @favorite = @user.favorites.find_by(product_id: params[:id])
    @favorite.destroy
    redirect_to :back
  end

  # GET user add information


  def search
      if @query_string.present?
        search_result = Product.ransack(@search_criteria).result(:distinct => true)
        @products = search_result.paginate(:page => params[:page], :per_page => 5 )
      end
  end


    protected

    def validate_search_key
      @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
      @search_criteria = search_criteria(@query_string)
    end


    def search_criteria(query_string)
      { :title_cont => query_string }
    end

end
