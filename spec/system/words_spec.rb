require 'rails_helper'

RSpec.describe "Words", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context "create, edit & delete the word" do 
    it '正しい情報を入力すればwordが新規登録・編集・削除できる' do
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      visit root_path
    
      # category
      expect(page).to have_content('+')
      find('.card_add').click

      fill_in 'カテゴリ名', with: 'テストカテゴリ'
      expect {
        click_button '作成'
        sleep 1
      }.to change { Category.count }.by(1)

      # word
      category = Category.last
      visit category_path(category)

      expect(page).to have_content('+')
      find('.card_show_add').click

      fill_in placeholder: 'Title', with: 'test'
      fill_in placeholder: 'Question', with: 'test'
      fill_in placeholder: 'Answer', with: 'テスト'

      expect {
        click_button '作成'
        sleep 1
      }.to change { Word.count }.by(1)

      # word edit
      word = Word.last
      visit category_word_path(category, word)
      click_button '☰'
      find('.menu-text', text: 'edit').click

      fill_in 'word_title', with: 'updated title'
      fill_in 'word_question', with: 'updated question'
      fill_in 'word_answer', with: '更新済み'
      click_button '更新'

      expect(page).to have_content('updated title')
      expect(page).to have_content('updated question')
      expect(page).to have_content('更新済み')

      # word delete
      click_button '☰'
      expect {
        accept_confirm do
          find('.menu-text', text: 'delete').click
        end
        sleep 1 
      }.to change { Word.count }.by(-1)
    end

    it '誤った情報を入力するとwordが新規登録できない' do
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      visit root_path
    
      # category
      expect(page).to have_content('+')
      find('.card_add').click

      fill_in 'カテゴリ名', with: 'テストカテゴリ'
      expect {
        click_button '作成'
        sleep 1
      }.to change { Category.count }.by(1)

      # word
      category = Category.last
      visit category_path(category)

      expect(page).to have_content('+')
      find('.card_show_add').click

      fill_in placeholder: 'Title', with: ''
      fill_in placeholder: 'Question', with: ''
      fill_in placeholder: 'Answer', with: ''
      click_button '作成'
    end

    it '誤った情報を入力するとwordが編集できない' do
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      visit root_path
    
      # category
      expect(page).to have_content('+')
      find('.card_add').click

      fill_in 'カテゴリ名', with: 'テストカテゴリ'
      expect {
        click_button '作成'
        sleep 1
      }.to change { Category.count }.by(1)

      # word
      category = Category.last
      visit category_path(category)

      expect(page).to have_content('+')
      find('.card_show_add').click

      fill_in placeholder: 'Title', with: 'test'
      fill_in placeholder: 'Question', with: 'test'
      fill_in placeholder: 'Answer', with: 'テスト'

      expect {
        click_button '作成'
        sleep 1
      }.to change { Word.count }.by(1)

      # word edit
      word = Word.last
      visit category_word_path(category, word)
      click_button '☰'
      find('.menu-text', text: 'edit').click

      fill_in 'word_title', with: ''
      fill_in 'word_question', with: ''
      fill_in 'word_answer', with: ''
      click_button '更新'
    end
  end
end
