require 'rails_helper'

RSpec.describe "Users", type: :system do
  

  context "signup" do
    before do
      @user = FactoryBot.build(:user)
    end

    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      visit root_path
      expect(page).to have_content('REGISTER')
      visit new_user_registration_path
    
      fill_in 'Name', with: @user.name
      fill_in 'Nickname', with: @user.nickname
      page.execute_script("document.getElementById('user_color_id').value = '#{Color.first.id}'")
      fill_in 'Email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      attach_file 'user_profile_pic', Rails.root.join('spec/fixtures/files/test_image.png')
    
      expect {
        click_button 'Register'
        sleep 1
      }.to change { User.count }.by(1)
    
      expect(page).to have_current_path(root_path)
    
      expect(find('.login_out').find('p').hover).to have_content('logout')
      expect(page).to have_no_content('REGISTER')
      expect(page).to have_no_content('LOGIN')
    end    

    it '誤った情報ではユーザー新規登録ができない' do
      visit root_path
      expect(page).to have_content('REGISTER')
      visit new_user_registration_path

      fill_in 'Name', with: ''
      fill_in 'Nickname', with: ''
      page.execute_script("document.getElementById('user_color_id').value = '#{Color.first.id}'")
      fill_in 'Email', with: @user.email
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'wrongpassword'
      attach_file 'user_profile_pic', Rails.root.join('spec/fixtures/files/test_image.png')

      expect {
        click_button 'Register'
        sleep 1
      }.to change { User.count }.by(0)

      expect(page).to have_current_path(new_user_registration_path, ignore_query: true)
    end
  end

  context "login" do
    before do
      @user = FactoryBot.create(:user)
    end

    it '正しい情報を入力すればloginできてトップページに移動する' do
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'
    
      expect(page).to have_current_path(root_path)
    
      expect(find('.login_out').find('p').hover).to have_content('logout')
      expect(page).to have_no_content('REGISTER')
      expect(page).to have_no_content('LOGIN')
    end

    it '誤った情報ではloginできない' do
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: ''
      fill_in 'user[password]',with: @user.password
      click_button 'Login'
    
      expect(page).to have_current_path(user_session_path, ignore_query: true)
    end
  end
end
