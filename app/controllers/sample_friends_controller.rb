class FriendsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @categories = Category.all
  end

  def create
    friend = User.find_by(email: params[:friend_email])
    if friend && current_user.friends.exclude?(friend)
      current_user.friends << friend
      flash[:notice] = "#{friend.nickname} を追加しました"
    else
      flash[:alert] = "追加できませんでした"
    end
    redirect_to request.referer
  end

  def destroy
    friend = User.find(params[:id])
    if current_user.friends.include?(friend)
      current_user.friends.delete(friend)
      flash[:notice] = "#{friend.name} を削除しました"
    else
      flash[:alert] = "削除できませんでした"
    end
    redirect_to request.referer
  end

  def edit
  end

  def update
  end


  
end
