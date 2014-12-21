class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy ]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    # @users = User.all
    @users = User.order('id').paginate(:page => params[:page],
                           per_page: 5)
  end

  def show
    @user = User.find(params[:id])
    # 仮に他ユーザ情報がみせない時の権限チェック
    # if !current_user?(@user)
    #   flash[:error] = "you can not access others"
    #   redirect_to current_user
    # end
  end

  def new
    if signed_in?
      redirect_to root_url and return
    end
    @user = User.new

  end

  def create

    if signed_in?
      redirect_to root_url and return
    end
    @user = User.new(user_params)    # 実装は終わっていないことに注意!
    if @user.save
      # 保存の成功をここで扱う。
      sign_in(@user)
      flash[:success] = "Welcome to Sample app"
      # redirect_to user_url(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      flash[:notice] = "You can not delete admin user."
    else
      @user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before actions

  def signed_in_user
    store_location
    # TODO 元はsignin_url, なぜ
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end


  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end


end
