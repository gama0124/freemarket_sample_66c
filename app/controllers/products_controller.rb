class ProductsController < ApplicationController
  
  before_action :set_product, except: [:index, :new, :create, :update, :order, :pay, :complete, :search]
  def index
    @products = Product.includes(:images).order('created_at DESC')
  end

  def new
    @product = Product.new
    @product.images.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @product = Product.find(params[:product_id])
    if @product.update(product_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to root_path
  end

  def show
    @contents = Product.includes(:images).order('created_at DESC')
  end

  def order
    if user_signed_in?
      @product = Product.find(params[:product_id])
      card = Card.where(user_id: current_user.id).first
      if card.blank?
        #登録された情報がない場合にカード登録画面に移動
        redirect_to controller: "users/registrations", action: "new_card"
      else
        Payjp.api_key = ENV['PAYJP_ACCESS_KEY']
        #保管した顧客IDでpayjpから情報取得
        customer = Payjp::Customer.retrieve(card.customer_id)
        #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
        @default_card_information = customer.cards.retrieve(card.card_id)
      end
    else
      redirect_to users_login_path
    end
  end

  def pay
    @product = Product.find(params[:product_id])
    card = Card.where(user_id: current_user.id).first
    Payjp.api_key = ENV['PAYJP_ACCESS_KEY']
    Payjp::Charge.create(
    :amount => @product.price, #支払金額を入力（itemテーブル等に紐づけても良い）
    :customer => card.customer_id, #顧客ID
    :currency => 'jpy', #日本円
    ) #完了画面に移動
    redirect_to product_complete_path(params[:product_id])
  end

  def complete
    @product = Product.find(params[:product_id])
  end

  def search
    @search = params[:search]
    @products = Product.search(@search)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  private
  
  def product_params
    params.require(:product).permit(:name, :detail, :brand, :size, :price, :status, :situation, :postage, :method, :area, :category_parents, :category_children, :category_grand_children, images_attributes: [:image_url, :_destroy, :id]).merge(user_id: current_user.id)
  end
end