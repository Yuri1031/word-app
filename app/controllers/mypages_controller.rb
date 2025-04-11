class MypagesController < ApplicationController
  def index
    @categories = Category.all
    @users = User.all
  end

  def show
    @categories = Category.includes(words: :word_marks)
    @user = current_user
    @matchers = current_user.matchers
    @friends = current_user.matchers
    @chart_data = {}
  
    @categories.each do |category|
      total_words = category.words.count
  
      marked_words = category.words.joins(:word_marks)
                             .where(word_marks: { dif: 1, user_id: current_user.id })
                             .distinct.count
      unmarked_words = total_words - marked_words
  
      if total_words.zero?
        @chart_data[category.id] = {
          "⚪︎" => 0,
          "×" => 0
        }
      else
        @chart_data[category.id] = {
          "⚪︎" => ((unmarked_words.to_f / total_words) * 100).round(1),
          "×" => ((marked_words.to_f / total_words) * 100).round(1)
        }
      end
    end
  
    @chart_color = current_user.color.name
  end
  
  
end
