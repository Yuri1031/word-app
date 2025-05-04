require 'rails_helper'

RSpec.describe "Studies", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @category = FactoryBot.create(:category, user: @user, category_name: "テストカテゴリ")
    @word1 = FactoryBot.create(:word, title: "単語A", category: @category, user: @user)
    @word2 = FactoryBot.create(:word, title: "単語B", category: @category, user: @user)
    FactoryBot.create(:word_mark, user: @user, word: @word2) 

    visit user_session_path
    fill_in 'user[email]', 
    with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'Login'
  end

  it 'カテゴリ一覧が表示され、クリックでカテゴリ詳細に遷移できる' do
    visit studies_path

    expect(page).to have_content("テストカテゴリ")

    click_link "テストカテゴリ"

    expect(page).to have_content("単語A")
    expect(page).to have_content("単語B")
  end

  it '「マークのみ」フィルタが機能し、マークされた単語だけが表示される' do
    visit study_path(@category)

    choose 'マークのみ'  
    click_button 'OK'

    expect(page).to have_content("単語B")
    expect(page).not_to have_content("単語A")
  end

  it '「ランダム」並び替えが機能する' do
    visit study_path(@category)

    choose 'ランダム'
    click_button 'OK'

    expect(page).to have_content("単語A")
    expect(page).to have_content("単語B")
  end
end
