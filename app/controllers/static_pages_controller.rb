class StaticPagesController < ApplicationController
  def home
    # todo what is difference between the build and new
    @micropost = current_user.microposts.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
