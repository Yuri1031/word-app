require 'rails_helper'

RSpec.describe "Studies", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user: user) }
  let!(:word) { FactoryBot.create(:word, category: category, user: user) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "studyが正常に表示されること" do
      get studies_path
      expect(response.status).to eq(200)  
      expect(response.body).to include(category.category_name)
    end
  end

  describe "GET /show" do
    it "categoryが正常に表示されること" do
      get study_path(category)
      expect(response.status).to eq(200)  
      expect(response.body).to include(word.title)
    end

    it "markedソートでマーク済み単語だけ取得できること" do
      FactoryBot.create(:word_mark, word: word, user: user)
      get study_path(category, filter: 'marked')
      expect(response.body).to include(word.title)
    end

    it "ランダムソートでも表示できること" do
      get study_path(category, params: { order: 'random' })
      expect(response.status).to eq(200)
    end

  end

end
