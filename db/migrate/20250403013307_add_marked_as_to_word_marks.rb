class AddMarkedAsToWordMarks < ActiveRecord::Migration[7.1]
  def change
    add_column :word_marks, :marked_as, :boolean
  end
end
