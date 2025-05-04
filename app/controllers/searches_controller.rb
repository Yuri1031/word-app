class SearchesController < ApplicationController
  def search
    if params[:q].present?
      keyword = params[:q][:keyword] 
  
      @users = []
      
      gids = current_user.groups.ids
  
      base_words = if gids.any?
        Word.left_outer_joins(:group_words)
            .where("words.user_id = :uid OR group_words.group_id IN (:gids)", uid: current_user.id, gids: gids)
            .where.not(group_words: { id: nil })
      else
        Word.where(user_id: current_user.id)
      end
  
      @words = base_words.where("title LIKE :kw OR question LIKE :kw OR answer LIKE :kw", kw: "%#{keyword}%")
  
      @categories = current_user.categories
                      .where("category_name LIKE ?", "%#{keyword}%")
  
      @groups = current_user.groups
                  .where("group_name LIKE ?", "%#{keyword}%")
    else
      @users = []
      @words = []
      @categories = []
      @groups = []
    end
  
    respond_to do |format|
      format.html
      format.json { render json: { users: @users, words: @words, categories: @categories, groups: @groups } }
    end
  end
  

  def suggestions
    query = params[:q]
    suggestions = Category.where("category_name LIKE ?", "%#{query}%").limit(5).pluck(:category_name)
    render json: suggestions
  rescue => e
    render json: { error: "Something went wrong: #{e.message}" }, status: :unprocessable_entity
  end

  private
  def search_params
    params.fetch(:q, {}).permit(:query)
  end
end