require 'rails_helper'

RSpec.describe "Categories", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context "create the category" do 
    it '正しい情報を入力するとcategoryが新規登録ができてトップページに移動する' do
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      visit root_path
    
      expect(page).to have_content('+')
      find('.card_add').click

      fill_in 'カテゴリ名', with: 'テストカテゴリ'
      expect {
        click_button '作成'
        sleep 1
      }.to change { Category.count }.by(1)
    end

    it '誤った情報を入力するとcategoryが新規登録されない' do
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      visit root_path
    
      expect(page).to have_content('+')
      find('.card_add').click

      fill_in 'カテゴリ名', with: ''
      click_button '作成'
    
      expect(page).to have_current_path(root_path, ignore_query: true)
    end
  end

  context "delete the category" do 
    it '正しい情報を入力しcategory新規登録後、削除' do
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      visit root_path
    
      expect(page).to have_content('+')
      find('.card_add').click

      fill_in 'カテゴリ名', with: 'テストカテゴリ'
      expect {
        click_button '作成'
        sleep 1
      }.to change { Category.count }.by(1)

      expect(page).to have_current_path(categories_path)
      expect(page).to have_selector('.card_del', text: '×')
    end
  end
end
