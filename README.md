# ⚪︎Wordshelf
<br>

## ⚪︎アプリケーション概要
単語をカテゴリーごとに管理できるアプリです。本棚のように「並べる・選ぶ・振り返る」ことが可能です。
<br>

## ⚪︎URL
※ (デプロイが完了後記載予定)
<br>

## テスト用アカウント
Mail address: test@000.com
Passwprd: testtest
<br>

## ⚪︎開発のきっかけ
学生時代の経験から「単語を効率よく覚える方法」を見つけることに苦労していました。特に感じていた課題は、単語を覚えるだけで、後から見返すさないというものです。また、学んだ単語が増えるにつれて整理ができなくなり、単語帳使用が疎遠になることが多々ありました。そのため、自分だけの“語彙の本棚”のようなものがあればと考えるようになりました。
そんなとき、ある友人が「勉強した単語をグループで共有したい」と話していたのがきっかけで、単語を自分で管理でき、かつ必要に応じてグループ内でシェアできるアプリの必要性を実感しました。そこで、自分の学習体験とニーズをもとに、「並べる・選ぶ・振り返る」をキーワードにwordshelfを開発することを決意しました。
wordshelfは、語彙を自由なカテゴリーで整理し、本棚に本を並べるように単語を可視化することで、記憶の定着と復習のしやすさをサポートします。また、シェア機能を通じて、他の学習者と知識を共有する場も提供します。
<br>

## ⚪︎アプリ詳細
### ⚪︎開発環境
※※※※※ 確認してかく
<br>

### ⚪︎機能一覧
| ログイン画面 | サインイン画面 |
| ------------ | -------------- |
| <img src="https://github.com/user-attachments/assets/c4430d06-5508-4bc8-83ae-9e98b06103f3" width="400" />| <img src="https://github.com/user-attachments/assets/b64d22a3-b9b8-4294-af12-0c7bffca7ba2" width="400"/> |
| ログイン後サイトの所定の画面に遷移できる様になっています。                                    | 情報を登録後、所定の画面に遷移できる様になっています。       |

| My page画面                                                                                                  | Bookshelf画面                                                                                                  |
| ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/76553a0b-3c3f-4a20-bcb7-67ddc5c13f4f" width="400"/> | <img src="https://github.com/user-attachments/assets/f0c73909-f5a8-4005-9c0b-2e8b9f4fe5d4" width="400"/> |
| 自分のアカウント情報の編集やフォロー申請、フレンド一覧、学習記録が確認できる様になっています。                                    | 「＋」ボタンでカテゴリーを作成し、単語一覧に遷移できる様になっています。       |

| Bookshelf 単語一覧画面                                                                                                  | Bookshelf 単語詳細画面                                                                                                  |
| ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/285886f9-01b8-4933-ba7e-5bc727eab252" width="400"/> | <img src="https://github.com/user-attachments/assets/010ba713-4cdc-4568-ac13-66a7e4c3e781" width="400"/> |
| 「＋」ボタンで単語を作成、その後単語詳細に遷移できる様になっています。                                    | ハンバーガーメニュー内で単語カードの編集・削除・グループへ共有ができるようになっています。また、下部のトグルボタンをONにすると苦手と感じたカードとしてマークでき、Studyの本日のタスクで復習することが可能です。      |

| Study画面                                                                                                  | Study詳細画面                                                                                                  |
| ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/b72ba954-2a6f-4867-a1da-10a470def8b0" width="400" /> | <img src="https://github.com/user-attachments/assets/8d16fffa-57f1-4d06-845e-e8c88c6d596b" width="400" /> |
| 単語の見返しを目的にした仕様になっています。画面内には、「本日のタスク」と各「カテゴリー一覧」が表示されています。「本日のタスク」は間違えた単語を再度学習し、再び間違えたものに関しては3日後に表示されるようになっています。「カテゴリー一覧」は詳細表示に遷移すできるようになっています。                               | 「すべて or マークのみ」「順番 or ランダム」のフィルターを設定し、自由に単語の学習が行える様になっています。       |

| Group画面                                                                                                  | Group詳細画面                                                                                                  |
| ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/c3ea1a26-9b8a-4676-a9ab-89c0c2318b77" width="400" /> | <img src="https://github.com/user-attachments/assets/8ad842c8-d733-44f4-b643-96073cdff0e5" width="400" /> |
| 「＋」ボタンのグループ作成や、グループの一覧を表示し、グループ詳細画面に遷移できる様になっています。                               | グループアカウント情報の変更や単語の一覧表示ができる様になっています。単語一覧では、共有した単語カードが共有者の名前とともに表示され、単語詳細画面に遷移できる様になっています。       |
<br>

### ⚪︎**ER図
<img width="489" alt="Image" src="https://github.com/user-attachments/assets/c3725b72-ac6e-42b7-a1fd-946acbe24a48" />
<br>

### ⚪︎**データベース設計
#### users テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| name               | string     | null: false                    |
| nickname           | string     | null: false                    |
| color_id           | integer    | null: false                    | ← ActiveHashを使用。
| profile_pic        | text       |                                | ← ActiveStorageを使用。
| email              | string     | null: false, unique: true      |
| encrypted_password | string     | null: false                    |
- has_many :categories, dependent: :destroy
- has_many :words
- has_many :word_categories, through: :words, source: :category
- has_many :groups, through: :group_members
- has_many :group_members
- has_many :group_words
- has_many :word_marks, dependent: :destroy

#### words テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| title              | string     | null: false                    |
| question           | string     | null: false                    |
| answer             | string     | null: false                    |
| img                | string     |                                | ← ActiveStorageを使用。
| user               | references | null: false, foreign_key: true |
| category           | references | null: false, foreign_key: true |
- belongs_to :user
- belong_to :category
- has_many :word_marks, dependent: :destroy
- has_many :group_words, dependent: :destroy
- has_many :groups, through: :group_words


#### categories テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| category_name      | string     | null: false, unique: true      |
| category_img       | string     |                                | ← ActiveStorageを使用。
| user               | references | null: false, foreign_key: true |
- belong_to :user
- has_many :words, dependent: :destroy

#### word_marks テーブル -------------------------------------------
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| review_date        | datetime   |                                |
| mark_type          | integer    |                                |
| user               | references | null: false, foreign_key: true |
| word               | references | null: false, foreign_key: true |
- belongs_to :user
- belong_to :word

#### groups テーブル -------------------------------------------
 Column              | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| group_name         | string     | null: false                    |
| group_img          | string     |                                | ← ActiveStorageを使用。
| group_description  | text       | null: false                    |
| user               | references | null: false, foreign_key: true |
- belongs_to :user
- has_many :users, through: :group_members
- has_many :group_members, dependent: :destroy
- has_many :group_words, dependent: :destroy
- has_many :words, through: :group_words

#### group_members(中間)テーブル -------------------------------------------
 Column              | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| user               | references | null: false, foreign_key: true |
| group              | references | null: false, foreign_key: true |
- belongs_to :user
- belongs_to :group

#### group_words(中間)テーブル -------------------------------------------
 Column              | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| user               | references | null: false, foreign_key: true |
| group              | references | null: false, foreign_key: true |
| word               | references | null: false, foreign_key: true |
- belongs_to :user
- belongs_to :word
- belongs_to :group
<br>

### ⚪︎工夫した点
<details>
<summary>１. グループデータベースの最適化</summary>

- ユーザーの所属グループ管理と、各グループで共有される単語の関係を明確に分離するため、group_members テーブルと group_words テーブルを別々に設計しました。これにより、単語の共有履歴やアクセス制御の柔軟な拡張ができる様になっております。
</details>

<details>
<summary>２. 復習機能のユーザビリティ向上</summary>

- 単語カードにマークボタンを設けることで、苦手を明確化できるようにしました。
- 苦手とマークされた単語カードは「本日のタスク」として集約され、一括学習を可能にしております。
- さらに「本日のタスク」内で苦手とマークした単語は、3日後に再表示され記憶の定着を実現しております。
</details>

<details>
<summary>3. ユーザビリティとデザインの工夫</summary>

- ユーザーが直感的に操作できるよう、シンプルなデザインを心掛けました。
- 視覚的にわかるよう、新規登録は「＋」、削除は「×」といったマーク中心のデザインを意識しビューを作成しております。
</details>
<br>

## ⚪︎今後の課題及び追加予定機能
<details>
<summary>1. カテゴリー表示について</summary>

- カテゴリー内にさらにカテゴリーを作成し、より単語カードを整理できるようにする。
</details>

<details>
<summary>2. 単語作成機能</summary>

- 文字だけでなくマーカーや画像・動画等といったコンテンツも保存できる様にする。
</details>

<details>
<summary>3. 通知機能の強化</summary>

- お知らせ機能を追加し、フォローや復習の有無をお知らせさせる。
</details>

<details>
<summary>4. グループ内質問チャット機能の実装</summary>

- グループ内の単語に関して、チャット機能を設けて質問・回答を可能にし、理解を深める場にする。
</details>

<details>
<summary>5. 単語カードの保存機能の実装</summary>

- 共有されているグループ内の単語を自分のカードとして保存できる様にする。
</details>
<br>
