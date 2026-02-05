class V1::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item

  def create
    current_user.favorites.create!(item: @item)
    render json: { favorited: true }
  end

  def destroy
    current_user.favorites.find_by(item: @item)&.destroy
    render json: { favorited: false }
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
