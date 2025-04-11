class CreateWordMarks < ActiveRecord::Migration[7.1]
  def change
    create_table :word_marks do |t|
      t.integer :dif,          null: false, default: 0
      t.datetime :review_date, null: false

      t.references :word, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
