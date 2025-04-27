require 'rails_helper'

RSpec.describe GroupWord, type: :model do
  before do
    @group_word = FactoryBot.build(:group_word)
  end
  
  describe 'validation' do
    it '登録' do
      expect(@group_word).to be_valid
    end
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:group) }
    it { should belong_to(:word) }
  end
end
