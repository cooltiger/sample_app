class MicropostsController < ApplicationController

  before_action :signed_in_user ,only: [ :create, :destroy ]

  def index
  end

  def create
    # todo confirm here the build and new is same ,why
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_url
    else
      # render controller/action
      # to show the error message page itself
      render 'static_pages/home'
    end
  end

  def destroy
  end

end
