require 'rails_helper'

RSpec.describe Word, type: :model do
  before do
    @word = FactoryBot.build(:word)
  end
  
  describe 'validation' do
    it 'title, question, answerがあれば登録' do
      expect(@word).to be_valid
    end

    it 'titleが空で登録できない' do
      @word.title = nil
      expect(@word).not_to be_valid
    end

    it 'questionが空で登録できない' do
      @word.question = nil
      expect(@word).not_to be_valid
    end

    it 'answerが空で登録できない' do
      @word.answer = nil
      expect(@word).not_to be_valid
    end
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    
    it { should have_many(:word_marks) }
    it { should have_many(:group_words) }
    it { should have_many(:groups) }
  end
end
