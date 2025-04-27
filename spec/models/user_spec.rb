require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  
  describe 'validation' do
    it 'name, nickname, email, passwordがあれば登録' do
      expect(@user).to be_valid
    end

    it 'nameが空で登録できない' do
      @user.name = nil
      expect(@user).not_to be_valid
    end

    it 'nicknameが空で登録できない' do
      @user.nickname = nil
      expect(@user).not_to be_valid
    end

    it 'color_idが空で登録できない' do
      @user.color_id = nil
      expect(@user).not_to be_valid
    end

    it 'emailが空で登録できない' do
      @user.email = nil
      expect(@user).not_to be_valid
    end

    it 'passwordが空で登録できない' do
      @user.password = nil
      expect(@user).not_to be_valid
    end
  end

  describe 'association' do
    it { should have_many(:categories) }
    it { should have_many(:words) }
    it { should have_many(:group_words) }
    it { should have_many(:group_members) }
    it { should have_many(:groups).through(:group_members) }
    it { should have_many(:owned_groups).class_name('Group') }
    it { should have_many(:word_marks).dependent(:destroy) }
  end
end
