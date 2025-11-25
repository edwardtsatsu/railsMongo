class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    render json: UserService.fetch_all
  end

  def show
    render json: UserService.fetch(params[:id])
  end

  def create
    render json: UserService.create(user_params), status: :created
  end

  def update
    render json: UserService.update(@user, user_params)
  end

  def destroy
    render json: UserService.destroy(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: Oj.dump({ error: "User not found" }), status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :age, :email, :location)
  end
end
