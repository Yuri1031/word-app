class SearchesController < ApplicationController
  def search
    @q = User.ransack(params[:q])
    @users = params[:q].present? ? User.ransack(params[:q]).result : []
    @words = params[:q].present? ? Word.ransack(params[:q]).result : []
    @categories = params[:q].present? ? Category.ransack(params[:q]).result : []
    @groups = params[:q].present? ? Group.ransack(params[:q]).result : []
  
    respond_to do |format|
      format.html
      format.json { render json: { users: @users, words: @words, categories: @categories, groups: @groups } }
    end
  end

  def suggestions
    query = params[:q]
    suggestions = Course.where("title LIKE ?", "%#{query}%").limit(5).pluck(:title)
    render json: suggestions
  end
  

  private
  def search_params
    params.fetch(:q, {}).permit(:query)
  end
end