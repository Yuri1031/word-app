class CreateWords < ActiveRecord::Migration[7.1]
  def change
    create_table :words do |t|
      t.string   :title,      null: false
      t.string   :question,   null: false
      t.string   :answer,     null: false

      t.references :user,     null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
