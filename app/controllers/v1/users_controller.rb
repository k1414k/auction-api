class V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def my_profile
    render json: {
      id: current_user.id,
      name: current_user.name,
      nickname: current_user.nickname,
      email: current_user.email,
      balance: current_user.balance,
      points: current_user.points,
    }
  end
end
