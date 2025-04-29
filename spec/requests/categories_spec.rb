require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user: user) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "正常に表示されること" do
      get root_path
      expect(response.status).to eq(200)  
      expect(response.body).to include(category.category_name)
    end
  end

  describe "GET /show" do
    it "特定のcategoryが表示されること" do
      get category_path(category)
      expect(response.status).to eq(200)
      expect(response.body).to include(category.category_name)
      category.words.each do |word|
        expect(response.body).to include(word.title)
      end
    end
  end

  describe "POST /create" do
    context "有効なパラメータの場合" do
      it "categoryを作成しリダイレクトされること" do
        expect {
          post categories_path, params: { category: { category_name: "New Category" } }
        }.to change(Category, :count).by(1)
        expect(response).to redirect_to(categories_path)
      end
    end

    context "無効なパラメータの場合" do
      it "categoryが作成されず、エラーになること" do
        expect {
          post categories_path, params: { category: { category_name: "" } }
        }.not_to change(Category, :count)
        expect(response.status).to eq(422)  
      end
    end
  end

  describe "DELETE /destroy" do
    it "categoryが削除されること" do
      expect {
        delete category_path(category)
      }.to change(Category, :count).by(-1)
      expect(response).to redirect_to(categories_path)
    end
  end
end
