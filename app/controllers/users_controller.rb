class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    redirect_to @user, notice:  "Yes !!!!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  def update
  end

  def destroy
  end

  private
  def user_params
  params.require(:user).permit(:email_address ,:name, :last_name, :password, :password_confirmation, :date_of_birth)
  end
end
