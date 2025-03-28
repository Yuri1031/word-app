class MypagesController < ApplicationController
  def index
    @categories = Category.all
    @users = User.all
  end
end
