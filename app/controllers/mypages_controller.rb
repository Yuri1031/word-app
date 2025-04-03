class MypagesController < ApplicationController
  def index
    @categories = Category.all
    @users = User.all
  end

  def show
    @categories = Category.all.includes(:words)
    @category_understanding = {}
  
    @categories.each do |category|
      total_words = category.words.count
      marked_words = category.words.joins(:word_marks).where(word_marks: { marked_as: true }).count
      understanding = total_words.zero? ? 100 : (100 - (marked_words.to_f / total_words * 100)).to_i
      @category_understanding[category.id] = understanding
    end
  end
  
  
end
