class CreateGroupWords < ActiveRecord::Migration[7.1]
  def change
    create_table :group_words do |t|
      t.references :word, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
