require 'rails_helper'

RSpec.describe "Mypages", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user: user, category_name: "TestCategory") }
  let!(:word) { FactoryBot.create(:word, category: category, user: user) }

  before do
    sign_in user
  end

  describe "GET /show" do
    it "mypageが正常に表示されること" do
      get mypage_path
      expect(response.status).to eq(200)  
      expect(response.body).to include(user.nickname)
      expect(response.body).to include(user.name)
    end

    it "category情報が見えること" do
      get mypage_path
      expect(response.body).to include(category.category_name)
    end

    it "chartに⚪︎と×が含まれていること" do
      get mypage_path
      expect(response.body).to match(/⚪︎/)
      expect(response.body).to match(/×/)
    end
  end
end
