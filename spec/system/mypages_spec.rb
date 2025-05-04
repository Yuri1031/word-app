require 'rails_helper'

RSpec.describe "Mypages", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context "edit my page" do 
    it '正しい情報を入力すればmy pageが編集できる' do
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'
      visit root_path

      # my page
      visit mypage_path
      expect(page).to have_selector('.si.Mypage')

      find('.mypage_settings_icon').click
      expect(page).to have_selector('input[name="user[name]"]', visible: true, wait: 5)

      find('input[name="user[name]"]').set('updated name')
      find('input[name="user[nickname]"]').set('updated nickname')
      click_button '更新'

      expect(page).to have_content('updated name')
      expect(page).to have_content('updated nickname')
    end

    it 'プロフィール画像をアップロードできること' do
      visit user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'
    
      visit mypage_path
      find('.mypage_settings_icon').click
      expect(page).to have_selector('input[name="user[name]"]', visible: true, wait: 5)
    
      attach_file('user[profile_pic]', Rails.root.join('spec/fixtures/sample.png'))
      click_button '更新'
    
      expect(page).to have_selector('img.mypage_user_img')
    end
    
    it '誤った情報のときは登録されない' do
      visit mypage_path
      expect(Group.count).to eq(0)
    end
  end

  context "add & delete friends" do 
    it 'friendを検索して申請できる' do
      friend = FactoryBot.create(:user, email: 'friend@example.com', nickname: 'フレンド')

      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'
      visit root_path

      # my page
      visit mypage_path
      
      find('.friends_icon').click
      expect(page).to have_selector('form#friend_search_form', visible: true)

      fill_in 'メールアドレスを入力', with: 'friend@example.com'
      click_button '検索'

      expect(page).to have_content('フレンド')
      click_button '追加' 

      expect(page).to have_content('申請取消') 
    end

    it 'friendを検索して申請後、waiting listに表示される' do
      friend = FactoryBot.create(:user, email: "friend_#{SecureRandom.hex(4)}@example.com", nickname: 'フレンド')
    
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'
      visit root_path

      # my page
      visit mypage_path
      find('.friends_icon').click
      expect(page).to have_selector('form#friend_search_form', visible: true)
    
      fill_in 'メールアドレスを入力', with: friend.email
      click_button '検索'
    
      expect(page).to have_content('フレンド')
      click_button '追加'
    
      expect(page).to have_selector('#waiting_list', text: 'フレンド（申請中）', wait: 5)
    end

    it 'friend申請後、承認し、friend_listに表示・削除される' do
      friend = FactoryBot.create(:user, email: "friend_#{SecureRandom.hex(4)}@example.com", nickname: 'フレンド')
    
      # ユーザーAでログインして申請
      visit user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'Login'
      visit mypage_path
      find('.friends_icon').click
    
      fill_in 'メールアドレスを入力', with: friend.email
      click_button '検索'
      click_button '追加'
      expect(find('.login_out').find('p').hover).to have_content('logout')
      visit destroy_user_session_path
      Capybara.reset_sessions!
    
      # friend 側でログインして申請承認
      visit user_session_path
      fill_in 'user[email]', with: friend.email
      fill_in 'user[password]', with: friend.password
      click_button 'Login'
      visit mypage_path
      find('.friends_icon').click
      expect(page).to have_selector('#waiting_list', text: @user.nickname)
      click_button '承認'
      expect(find('.login_out').find('p').hover).to have_content('logout')
      visit destroy_user_session_path
      Capybara.reset_sessions!
    
      # ユーザーA再ログインして friend_list に表示されるか確認
      visit user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'Login'
      visit mypage_path
      expect(page).to have_selector('#friend_list', wait: 5)
      expect(page).to have_selector('#friend_list', text: 'フレンド')
    
      # 削除ボタンでフレンド削除
      within all('#friend_list').first do
        accept_confirm do
          find('.friend_remove_link').click
        end
      end
    
      expect(page).to have_no_selector('#friend_list', text: 'フレンド')
    end    
  end  
end
