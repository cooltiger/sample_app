class MicropostsController < ApplicationController

  before_action :signed_in_user ,only: [ :create, :destroy ]
  before_action :correct_user ,only: [ :destroy ]

  def index
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_url
    else
      # to show the error message page itself
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
      # render controller/action
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    # go back to the url referer
    redirect_to request.referer
  end

  private
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
