require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @category = FactoryBot.build(:category)
  end
  
  describe 'validation' do
    it 'category_nameがあれば登録' do
      expect(@category).to be_valid
    end

    it 'category_nameが空で登録できない' do
      @category.category_name = nil
      expect(@category).not_to be_valid
    end
  end

  describe 'association' do
    it { should belong_to(:user) }

    it { should have_many(:words) }
  end
end
