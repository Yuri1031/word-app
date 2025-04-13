class StudiesController < ApplicationController
  def index
    @categories = Category.all.includes(:words)
    @word = Word.first
  end
  
  def show
    @category = Category.find(params[:id])
    @words = @category.words.includes(:word_marks)
  
    if params[:filter] == 'marked'
      @words = @words.joins(:word_marks).where(word_marks: { dif: 1 }).distinct
    end
  
    if params[:order] == 'random'
      @words = @words.shuffle
    else
      @words = @words.order(:id)
    end
  end

  
end
