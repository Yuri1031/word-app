require 'rails_helper'

RSpec.describe "Groups", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context "create the group" do 
    it '正しい情報を入力すればgroupが新規登録できる' do
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      # group
      visit groups_path
      expect(page).to have_content('Group') 

      expect(page).to have_content('+')
      find('.group_create').click

      fill_in 'group[group_name]', with: 'グループ'
      fill_in 'group[group_description]', with: 'グループ説明'
      
      expect {
        click_button '作成'
        sleep 1
      }.to change { Group.count }.by(1)
    end

    it '誤った情報だとgroupが新規登録できない' do
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      # group
      visit groups_path
      expect(page).to have_content('Group') 

      expect(page).to have_content('+')
      find('.group_create').click

      fill_in 'group[group_name]', with: ''
      fill_in 'group[group_description]', with: ''

      expect(Group.count).to eq(0)
      expect(page).to have_selector('.modal', visible: true)
    end
  end

  context "delete the group" do 
    it 'groupが削除でき削除後にメンバー数が-1であること' do
      # login
      visit root_path
      expect(page).to have_content('LOGIN')
      visit user_session_path
    
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]',with: @user.password
      click_button 'Login'

      # group
      visit groups_path
      expect(page).to have_content('Group') 

      expect(page).to have_content('+')
      find('.group_create').click

      fill_in 'group[group_name]', with: 'グループ'
      fill_in 'group[group_description]', with: 'グループ説明'
      
      expect {
        click_button '作成'
        sleep 1
      }.to change { Group.count }.by(1)
      
      # group delete
      visit groups_path
      expect(page).to have_content('Group')
      
      group = Group.last
      original_count = group.group_members.count

      find('.card_del', match: :first).click

      expect {
        page.accept_confirm 'Are you sure? Do you want to leave this group?'
        expect(page).to have_content ('Group')
      }.to change { group.group_members.count }.by(-1)

      expect(page).to have_css('.gmember_img', count: original_count - 1)
    end
  end
end
