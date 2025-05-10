class StudiesController < ApplicationController
  def index
    @categories = current_user.categories.includes(:words)
    @word = Word.first   
  end
  
  def show
    session[:previous_page] = request.fullpath
    @category = Category.find(params[:id])
    @words = Word.includes(:word_marks)
                 .where(category_id: @category.id) 
  
    if params[:filter] == 'marked'
      @words = @words.joins(:word_marks)
                     .where(word_marks: { user_id: current_user.id})
                     .distinct
    end
                
    if params[:order] == 'random'
      @words = @words.shuffle
     else
      @words = @words.order(:id)
    end
  end  
end
