# テーブル設計
## users テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| name               | string     | null: false                    |
| nickname           | string     | null: false                    |
| color_id           | integer    | null: false                    | ← ActiveHash予定。
| profile_pic        | text       |                                | ← ActiveStorageにより不要。
| email              | string     | null: false, unique: true      |
| encrypted_password | string     | null: false                    |

- has_many :words
- has_many :group_members
- has_many :groups, through: :group_members



## words テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| title              | string     | null: false                    |
| question           | string     | null: false                    |
| answer             | string     | null: false                    |
| img                | string     |                                | ← ActiveStorageにより不要。
| user               | references | null: false, foreign_key: true |
| category           | references | null: false, foreign_key: true |

- belongs_to :user
- belong_to :category
- has_one :word_mark, dependent: :destroy
- has_many :group_words, dependent: :destroy
- has_many :groups, through: :group_words



## categories テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| category_name      | string     | null: false, unique: true      |
| category_img       | string     |                                | ← ActiveStorageにより不要。

- has_many :words



## word_marks テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| dif                | integer    | null: false, default: 0        |
| review_date_id     | datetime   | null: false                    |
| word               | references | null: false, foreign_key: true |

enum dif_level: { easy: 0, normal: 1, hard: 2 }

- belong_to :word



## groups テーブル -------------------------------------------
 Column              | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| group_name         | string     | null: false                    |
| group_img          | string     |                                | ← ActiveStorageにより不要。

- has_many :users, through: :group_members
- has_many :group_members, dependent: :destroy
- has_many :group_words, dependent: :destroy
- has_many :words, through: :group_words



## group_members(中間)テーブル -------------------------------------------
 Column              | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| user               | references | null: false, foreign_key: true |
| group              | references | null: false, foreign_key: true |

- belongs_to :user
- belongs_to :group



## group_words(中間)テーブル -------------------------------------------
 Column              | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| word               | references | null: false, foreign_key: true |
| group              | references | null: false, foreign_key: true |

- belongs_to :word
- belongs_to :group