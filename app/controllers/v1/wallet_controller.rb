class V1::WalletController < ApplicationController
  before_action :authenticate_user!

  # GET /v1/wallet
  def show
    render json: wallet_json
  end

  # PATCH /v1/wallet/balance
  def update_balance
    amount = params.require(:amount).to_i

    ActiveRecord::Base.transaction do
      current_user.lock! #同時変更塞ぐ
      current_user.balance += amount
      current_user.save!
    end

    render json: wallet_json
  rescue ActiveRecord::RecordInvalid
    render json: { error: "balance update failed" }, status: :unprocessable_entity
  end

  # PATCH /v1/wallet/points
  def update_points
    amount = params.require(:amount).to_i

    ActiveRecord::Base.transaction do
      current_user.lock!
      current_user.points += amount
      current_user.save!
    end

    render json: wallet_json
  rescue ActiveRecord::RecordInvalid
    render json: { error: "points update failed" }, status: :unprocessable_entity
  end

  private

  def wallet_json
    {
      balance: current_user.balance,
      points: current_user.points
    }
  end
end