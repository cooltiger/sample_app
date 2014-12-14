class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # todo 一時的にチェックを入れて、権限チェック
    # 考慮が必要があるのは、admin権限の人もみれるようにチェック
    if (@user.remember_token != User.encrypt(cookies[:remember_token]))
      redirect_to signin_path
    end
  end

  def new
    @user = User.new
  end

  def create
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

end
