class RelationshipsController < ApplicationController
  before_action :signed_in_user, only: [ :create, :destroy ]
  before_action :correct_user,   only: [ :create, :destroy ]

  def create
  end

  def destroy
  end

  def correct_user
    # todo [WIP]
    # @user = User.find(params[:id])
    # redirect_to(root_path) unless current_user?(@user)
  end

end

