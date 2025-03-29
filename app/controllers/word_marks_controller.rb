class WordMarksController < ApplicationController
  before_action :set_word

  def index 
    @word = Word.first 
    @categories = Category.all
  end

  def toggle
    word_mark = @word.word_marks.first

    if word_mark
      new_dif = word_mark.dif == 1 ? 0 : 1
      word_mark.update(dif: new_dif)
      render json: { status: 'updated', dif: new_dif }
    else
      word_mark = @word.word_marks.create(dif: 1, review_date_id: Time.current)
      render json: { status: 'created', dif: 1 }
    end
  end

  private
  def set_word
    @word = Word.find_by(id: params[:word_id])
    unless @word
      render json: { error: 'Word not found' }, status: :not_found
    end
  end
end
