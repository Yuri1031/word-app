class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friends do |t|
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :friends, [:user_id, :friend_id], unique: true
  end
end
