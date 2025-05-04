require 'rails_helper'

RSpec.describe "WordMarks", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @category = FactoryBot.create(:category, user: @user, category_name: "テストカテゴリ")
    @word1 = FactoryBot.create(:word, title: "単語A", category: @category, user: @user)
    @word2 = FactoryBot.create(:word, title: "単語B", category: @category, user: @user)
  end

  it '本日のタスク→⚪︎が機能すること' do
    # login
    visit user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'Login'
  
    # study 「本日のタスク」
    WordMark.create!(word: @word1, user: @user, review_date: Date.today)    
    visit studies_path
    find('a', text: "本日のタスク").click

    find('div.card_name', text: "テストカテゴリ").click

    # study ⚪︎
    expect(page).to have_content("単語A")
    find('button.mark-button.correct').click

    visit studies_path
    find('a', text: "本日のタスク").click
    expect(page).not_to have_content("単語A")
  end 

  it '本日のタスク→×が機能すること' do
    # login
    visit user_session_path
    fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_button 'Login'
    
    # study 「本日のタスク」
    WordMark.create!(word: @word1, user: @user, review_date: Date.today)    
    visit studies_path
    find('a', text: "本日のタスク").click
    find('div.card_name', text: "テストカテゴリ").click
    expect(page).to have_content("単語A")

    # study ×
    find('button.mark-button.wrong').click

    visit studies_path
    find('a', text: "本日のタスク").click
    find('div.card_name', text: "テストカテゴリ").click
    expect(page).not_to have_content("単語A")

    travel_to(Date.today + 3) do
      visit studies_path
      find('a', text: "本日のタスク").click
      find('div.card_name', text: "テストカテゴリ").click
      expect(page).to have_content("単語A")
    end
  end
end
