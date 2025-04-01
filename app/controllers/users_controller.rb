class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  def index
    @users = User.all
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

  def show
  puts "Params: #{params.inspect}"
  @user = User.find(params[:id])
  end

  def edit
  @user = User.find(params[:id])
  end 

  def update
  @user = User.find(params[:id])
  if @user.update(user_params)
    redirect_to @user, notice: "Profil mis à jour avec succès !"
  else
    render :edit, status: :unprocessable_entity
  end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: "Déconnecté avec succès"
  end

  private
  def user_params
  params.require(:user).permit(:email_address, :name, :last_name, :password, :password_confirmation, :date_of_birth)
  end
end
