class CreateWordMarks < ActiveRecord::Migration[7.1]
  def change
    create_table :word_marks do |t|
      t.datetime :review_date
      t.datetime :last_marked_at
      t.integer :mark_type

      t.references :word, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
