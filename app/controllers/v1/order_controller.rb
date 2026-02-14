class V1::OrderController < ApplicationController
  before_action :authenticate_user

  def create
    item = Item.find(params[:item_id])
    
    # 全ての処理が成功するか、全て失敗するかを保証する transaction
    ActiveRecord::Base.transaction do
      # 1. オーダーを作成（配送先情報をスナップショットとして保存）
      Order.create!(
        item: item,
        buyer_id: current_user.id,
        seller_id: item.user_id,
        shipping_address: "#{params[:shipping_name]} #{params[:shipping_address]}", # 名前と住所を合体させて保存
        status: 1
      )

      # 2. ユーザーの「最後に使った住所」を更新
      current_user.update!(
        last_name: params[:shipping_name],
        last_address: params[:shipping_address]
      )

      # 3. 商品を「取引中」にする
      item.update!(trading_status: :trading)

      # ※ ここで残高を減らす処理などを追加しても良い
    end

    render json: { message: "success" }, status: :ok
  rescue => e
    # 何か一つでも失敗すれば、DBは自動で元の状態に戻る（ロールバック）
    render json: { error: e.message }, status: :unprocessable_entity
  end
end