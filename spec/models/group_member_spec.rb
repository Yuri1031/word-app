require 'rails_helper'

RSpec.describe GroupMember, type: :model do
  before do
    @group_member = FactoryBot.build(:group_member)
  end
  
  describe 'validation' do
    it '登録' do
      expect(@group_member).to be_valid
    end
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  end
end
