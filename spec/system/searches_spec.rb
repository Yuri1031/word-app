require 'rails_helper'

RSpec.describe "Searches", type: :system do
  before do
    @user = FactoryBot.create(:user)
    FactoryBot.create(:category, user: @user, category_name: "テストカテゴリ1")
    FactoryBot.create(:category, user: @user, category_name: "テストカテゴリ2")
    FactoryBot.create(:category, user: @user, category_name: "サンプルカテゴリB")
  end

  context "検索機能" do
    it '複数のカテゴリ候補が表示され、そのうち1つに遷移できる' do
      # login
      visit user_session_path   
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      visit root_path
      find('input[name="q[keyword]"]', visible: :all).set("テスト")
      find('button[aria-label="検索"]').click
      sleep 1

      within('.search-results') do
        expect(page).to have_link("テストカテゴリ1")
        expect(page).to have_link("テストカテゴリ2")
        click_link "テストカテゴリ1"
      end
    
      expect(page).to have_content("テストカテゴリ1")
    end

    it '一致するカテゴリがない場合検索できない' do
      visit user_session_path   
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'Login'
  
      visit root_path
      find('input[name="q[keyword]"]', visible: :all).set("存在しないカテゴリ名")
      find('button[aria-label="検索"]').click
  
      expect(page).to have_selector('.search-results', visible: true)
      expect(page).to have_content("一致する結果がありません")
    end
  end  
end
