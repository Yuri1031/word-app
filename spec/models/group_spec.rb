require 'rails_helper'

RSpec.describe Group, type: :model do
  before do
    @group = FactoryBot.build(:group)
  end
  
  describe 'validation' do
    it 'group_name, group_descriptionがあれば登録' do
      expect(@group).to be_valid
    end

    it 'group_nameが空で登録できない' do
      @group.group_name = nil
      expect(@group).not_to be_valid
    end

    it 'group_descriptionが空で登録できない' do
      @group.group_description = nil
      expect(@group).not_to be_valid
    end
  end

  describe 'association' do
    it { should belong_to(:user) }
    
    it { should have_many(:users).through(:group_members) }
    it { should have_many(:group_members) }
    it { should have_many(:group_words) }
    it { should have_many(:words) }
  end
end

