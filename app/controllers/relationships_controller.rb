class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end
  
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to request.referer
  end
  # フォローしているユーザの一覧表示
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
  # フォローされているユーザの一覧表示
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
  
end
