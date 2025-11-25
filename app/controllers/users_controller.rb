class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  # GET /users?cursor=<id>&limit=10
  def index
    render json: UserService.fetch_all(cursor: params[:cursor], limit: params[:limit])
  end

  # GET /users/:id
  def show
    render json: UserService.fetch(@user.id)
  end

  # POST /users
  def create
    render json: UserService.create(user_params), status: :created
  end

  # PATCH/PUT /users/:id
  def update
    render json: UserService.update(@user, user_params)
  end

  # DELETE /users/:id
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
