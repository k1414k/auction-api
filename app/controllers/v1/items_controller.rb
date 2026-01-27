class V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create]
  
  def index
    items = Item.includes(images_attachments: :blob) # N+1 対策
    render json: items.map { |item|
      {
        **item.as_json,
        image: item.images.attached? ? url_for(item.images.first) : nil # thumbnail
      }
    }
  end

  def show
    item = Item.includes(images_attachments: :blob).find(params[:id])
    render json: {
        **item.as_json,
        images: item.images.map { |img| url_for(img) }
      }
  end

  def create
    p = item_params # 文字列で来る場合があるので整数形にする
    p[:condition] = p[:condition].to_i if p[:condition]
    p[:trading_status] = p[:trading_status].to_i if p[:trading_status]

    @item = current_user.items.build(p)
    if @item.save
      render json: @item, status: :created
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    head :no_content
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:title, :description, :price, :category_id, :condition, images: [])
  end
end
