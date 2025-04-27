require 'rails_helper'

RSpec.describe WordMark, type: :model do
  before do
    @word_mark = FactoryBot.build(:word_mark)
  end
  
  describe 'validation' do
    it '登録' do
      expect(@word_mark).to be_valid
    end
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:word) }
  end

  describe 'enum' do
    it 'correctとwrongが定義されている' do
      expect(WordMark.mark_types.keys).to include('correct', 'wrong')
    end
  end

  describe 'scopes' do
    it 'due_todayが存在する' do
      expect(WordMark.respond_to?(:due_today)).to be true
    end

    it 'recent_firstが存在する' do
      expect(WordMark.respond_to?(:recent_first)).to be true
    end

    it 'unmarked_firstが存在する' do
      expect(WordMark.respond_to?(:unmarked_first)).to be true
    end
  end
end
