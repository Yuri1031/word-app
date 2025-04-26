class WordMarksController < ApplicationController
  before_action :set_word, except: [:index, :update_review_date]

  def index
    @categories = Category.joins(words: :word_marks)
                          .where(word_marks: { user_id: current_user.id })
                          .where.not(word_marks: { review_date: nil })
                          .where('word_marks.review_date <= ?', Date.today)
                          .distinct
  
    session[:previous_page] = request.fullpath
  
    @today_words = WordMark.includes(:word)
                           .where(user: current_user)
                           .where('word_marks.review_date <= ?', Time.zone.today)
                           .unmarked_first
                           .map(&:word)

  
    @task_counts = {}
    @categories.each do |category|
      words = category.words
      task_count = WordMark.where(word: words, user: current_user)
                           .due_today
                           .count
      @task_counts[category.id] = WordMark.where(word: words, user: current_user)
                                          .where("review_date IS NULL OR review_date <= ?", Date.today)
                                          .count


    end
  end
  

  def toggle
    @word = Word.find(params[:word_id])
    word_mark = @word.word_marks.find_by(user_id: current_user.id)
  
    if word_mark
      word_mark.destroy
      render json: { status: 'deleted', mark_type: nil }
    else
      WordMark.create!(
        word: @word,
        user: current_user,
        review_date: Date.today,
        last_marked_at: Time.current
      )
      render json: { status: 'created', mark_type: 1 }
    end
  end

  def update_review_date
    word_mark = WordMark.find_or_initialize_by(word_id: params[:word_id], user_id: current_user.id)
  
    if params[:wrong].to_s == "true"
      word_mark.review_date = Time.zone.today + 3.days
      word_mark.mark_type = :wrong
     else
      word_mark.destroy and return render(json: { success: true })
    end
  
    word_mark.last_marked_at = Time.current
    word_mark.save!
  
    render json: { success: true }
  end
  

  private
  def set_word
    @word = Word.find_by(id: params[:word_id])
    unless @word
      render json: { error: 'Word not found' }, status: :not_found
    end
  end

  def next_review_date(_current_date)
    Date.today + 3.days
  end

end
