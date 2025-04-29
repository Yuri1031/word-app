require 'rails_helper'

RSpec.describe "Searches", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user, nickname: "FriendUser") }
  let(:group) { FactoryBot.create(:group, group_name: "TestGroup") }
  let(:category) { FactoryBot.create(:category, category_name: "TestCategory", user: user) }
  let(:word) { FactoryBot.create(:word, title: "TestTitle", question: "TestQuestion", answer: "TestAnswer", user: user, category: category) }
  let(:group_word) { FactoryBot.create(:group_word, group: group, word: word) }


  before do
    user.groups << group
    sign_in user
  end

  describe "GET /search" do
    context "検索キーワードが存在する場合" do
      it "users, words, categories, groupsを正常に取得できる" do
        word
        group_word
        friend 
    
        get search_searches_path, params: { q: { keyword: "Test" } }, as: :json
    
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
    
        expect(json["users"]).to be_an(Array)
        expect(json["words"]).to include(a_hash_including("title" => "TestTitle"))
        expect(json["categories"]).to include(a_hash_including("category_name" => "TestCategory"))
        expect(json["groups"]).to include(a_hash_including("group_name" => "TestGroup"))
      end
    end

    context "検索キーワードが存在しない場合" do
      it "users, words, categories, groupsが空配列になる" do
        get search_searches_path, params: {}, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["users"]).to eq([])
        expect(json["words"]).to eq([])
        expect(json["categories"]).to eq([])
        expect(json["groups"]).to eq([])
      end
    end
  end

  describe "GET /suggestions" do
    context "正常な場合" do
      it "カテゴリー名のsuggestionsを取得できる" do
        category # letを実行する

        get suggestions_searches_path, params: { q: "Test" }, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json).to include("TestCategory")
      end
    end

    context "例外発生時" do
      it "エラーメッセージを返す" do
        allow(Category).to receive(:where).and_raise(StandardError.new("DB error"))

        get suggestions_searches_path, params: { q: "Test" }, as: :json

        expect(response.status).to eq(422) 
        json = JSON.parse(response.body)

        expect(json["error"]).to match(/Something went wrong/)
      end
    end
  end
end
