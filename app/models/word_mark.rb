class WordMark < ApplicationRecord
  belongs_to :user
  belongs_to :word

  before_validation :set_default_review_date, on: :create

  enum mark_type: { unmarked: 0, correct: 1, wrong: 2 }

  scope :due_today, -> {
    where.not(review_date: nil)
      .where('review_date <= ?', Date.today)
  }

  scope :due_today, -> {
    where.not(review_date: nil)
         .where('review_date <= ?', Date.today)
  }

  scope :recent_first, -> {
    order(last_marked_at: :desc)
  }

  scope :unmarked_first, -> {
    order(Arel.sql("CASE WHEN mark_type = 0 OR mark_type IS NULL THEN 0 ELSE 1 END"), :last_marked_at => :desc)
  }


  private
  def set_default_review_date
    self.review_date ||= Date.today
  end

end
