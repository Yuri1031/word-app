class MypagesController < ApplicationController
  def index
    @categories = Category.all
    @users = User.all
  end

  def show
    @categories = Category.all.includes(:words)
    @category_understanding = {}

    @user = current_user
    @matchers = current_user.matchers
    @friends = current_user.matchers
  
    @categories.each do |category|
      total_words = category.words.count
      marked_words = category.words.joins(:word_marks).where(word_marks: { marked_as: true }).count
      understanding = total_words.zero? ? 100 : (100 - (marked_words.to_f / total_words * 100)).to_i
      @category_understanding[category.id] = understanding
    end

    @chart_data = @categories.map do |category|
      @categories = Category.all.includes(words: :word_marks)
      total_words = category.words.count
      learned_count = category.words.select { |word| word.word_marks.any? }.count
      percentage = if total_words.zero?
                     0
                   else
                     ((total_words - learned_count).to_f / total_words * 100).round
                   end
  
      [category.category_name, percentage]
    end.to_h
  
    @chart_color = current_user.color.name
  end
  
  
end
