class MypagesController < ApplicationController
  def index
    @categories = Category.all
    @users = User.all
  end

  def show 
    @categories = Category.where(user_id: current_user.id).includes(words: :word_marks)
    @user = current_user
    @matchers = current_user.matchers
    @friends = current_user.matchers
    @incoming_requests = current_user.followers.reject { |u| current_user.following?(u) }
    @chart_data = {}
  
    @categories.each do |category|
      total_words = category.words.count
  
      marked_words = category.words.joins(:word_marks)
                             .where(word_marks: { user_id: current_user.id })
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
    @base_color = adjust_color(@chart_color, 93, 36, 44)
  end

  private
  def adjust_color(hex, r_add, g_add, b_add)
    return "#CCCCCC" if hex.nil?|| hex.delete("#").size != 6
    hex = hex.delete("#")
    r = [hex[0..1].to_i(16) + r_add, 255].min
    g = [hex[2..3].to_i(16) + g_add, 255].min
    b = [hex[4..5].to_i(16) + b_add, 255].min
    format("#%02X%02X%02X", r, g, b)
  end
end
