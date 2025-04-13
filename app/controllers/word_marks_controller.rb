class WordMarksController < ApplicationController
  before_action :set_word

  def index
    @categories = Category.joins(words: :word_marks)
                          .where(word_marks: { dif: 1 }) 
                          .distinct
    session[:previous_page] = request.fullpath
  end

  def toggle
    word_mark = @word.word_marks.find_by(user_id: current_user.id)

    if word_mark
      new_dif = word_mark.dif == 1 ? 0 : 1
      word_mark.update(dif: new_dif)
      render json: { status: 'updated', dif: new_dif }
    else
      word_mark = @word.word_marks.create(user_id: current_user.id, dif: 1, review_date: Time.current)
      render json: { status: 'created', dif: 1 }
    end
  end

  def update_review_date
    word_mark = WordMark.find_by(word_id: params[:word_id], user_id: current_user.id)

    if word_mark
      if params[:wrong] == "true"
        word_mark.review_date = next_review_date(word_mark.review_date)
      else
        word_mark.review_date = nil # ⚪︎を押したら復習日リセット
      end
      word_mark.save!
    end

    render json: { success: true, review_date: word_mark.review_date }
  end

  private
  def set_word
    @word = Word.find_by(id: params[:word_id])
    unless @word
      render json: { error: 'Word not found' }, status: :not_found
    end
  end

  def update_review_date
    word_mark = WordMark.find_or_initialize_by(word_id: params[:word_id], user_id: current_user.id)

    if params[:wrong] == "true"
      word_mark.review_date = next_review_date(word_mark.review_date)
    else
      word_mark.review_date = nil # ⚪︎を押したら復習日リセット
    end
    word_mark.save!

    render json: { success: true, review_date: word_mark.review_date }
  end

  private

  def next_review_date(current_date)
    return Date.today + 3.days if current_date.nil?
    case current_date - Date.today
    when 3 then Date.today + 5.days
    when 5 then Date.today + 7.days
    else Date.today + 3.days
    end
  end

end
