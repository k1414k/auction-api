class V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def my_profile
    render json: {
      name: current_user.name,
      nickname: current_user.nickname,
      email: current_user.email,
      balance: current_user.balance,
      points: current_user.points,
      introduction: current_user.introduction,
      role: current_user.role,
      avatar_url: current_user.avatar.attached? ? url_for(current_user.avatar) : nil
    }
  end


  MAX_BALANCE_TRANSACTION = 100_000
  MAX_POINTS_TRANSACTION  = 1_000_000
  ALLOWED_TYPES = %w[balance points].freeze
  def update_wallet
    amount = params.require(:amount).to_i
    type   = params.require(:type)

    return error("invalid type") unless ALLOWED_TYPES.include?(type)
    return error("amount must not be 0") if amount.zero?

    limit = type == "balance" ? MAX_BALANCE_TRANSACTION : MAX_POINTS_TRANSACTION
    return error("amount is too large") if amount.abs > limit

    current_user.with_lock do
      current_value = current_user.public_send(type)
      new_value = current_value + amount

      return error("insufficient #{type}") if new_value < 0

      current_user.update!(type => new_value)
    end

    render json: {
      balance: current_user.balance,
      points: current_user.points
    }
  end

  def update_avatar
    if params[:avatar].blank?
      return error("avatar is required")
    end

    current_user.avatar.attach(params[:avatar])

    render json: {
      avatar_url: url_for(current_user.avatar)
    }
  end

  def error(message)
    render json: { error: message }, status: :unprocessable_entity
  end


end
