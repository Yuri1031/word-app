require 'rails_helper'

RSpec.describe "Words", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user: user) }
  let!(:word) { FactoryBot.create(:word, category: category, user: user) }


  before do
    sign_in user
  end

  describe "GET /show" do
    it "正常に表示されること" do
      get category_word_path(category_id: category.id, id: word.id)
      expect(response.status).to eq(200)  
    end
  end

  describe "GET /new" do 
    it "wordが新規作成できること" do 
      get new_category_word_path(category)
      expect(response.status).to eq(200)  
    end
  end

  describe "POST /create" do
    context "有効なパラメータの場合" do
      it "wordを作成しリダイレクトされること" do
        expect {
          post category_words_path(category_id: category.id), params: { word: { title: "New Word", question: "Question?", answer: "Answer!" } }
        }.to change(Word, :count).by(1)
        expect(response).to redirect_to(category)
      end
    end

    context "無効なパラメータの場合" do
      it "title, question, answer全て空でwordが作成されないこと" do
        expect {
          post category_words_path(category_id: category.id), params: { word: { title: "", question: "", answer: "" } }
        }.not_to change(Word, :count)
        expect(response.status).to eq(422)  
      end

      it "titleが空でwordが作成されないこと" do
        expect {
          post category_words_path(category_id: category.id), params: { word: { title: "", question: "question?", answer: "answer!" } }
        }.not_to change(Word, :count)
        expect(response.status).to eq(422)  
      end

      it "questionが空でwordが作成されないこと" do
        expect {
          post category_words_path(category_id: category.id), params: { word: { title: "title", question: "", answer: "answer!" } }
        }.not_to change(Word, :count)
        expect(response.status).to eq(422)  
      end

      it "answerが空でwordが作成されないこと" do
        expect {
          post category_words_path(category_id: category.id), params: { word: { title: "title", question: "question?", answer: "" } }
        }.not_to change(Word, :count)
        expect(response.status).to eq(422)  
      end
    end
  end

  describe "GET /edit" do 
    context "有効なパラメータの場合" do
      it "wordが編集されリダイレクトされること" do
        expect {
          post categories_path, params: { category: { category_name: "New Category" } }
        }.to change(Category, :count).by(1)
        expect(response).to redirect_to(categories_path)
      end
    end
    context "無効なパラメータの場合" do
      it "wordが編集されないこと" do
        expect {
          post categories_path, params: { category: { category_name: "" } }
        }.not_to change(Category, :count)
        expect(response.status).to eq(422)  
      end
    end
  end

  describe "PUT /update" do 
    context "有効なパラメータの場合" do
      it "wordが更新されること" do 
        put category_word_path(category_id: category.id, id: word.id), params: { word: { title: "Updated Title" } }
        expect(response).to redirect_to(category_word_path(category, word))
        expect(word.reload.title).to eq("Updated Title")
      end
    end
    
    context "無効なパラメータの場合" do
      it "wordが更新されないこと" do
        put category_word_path(category_id: category.id, id: word.id), params: { word: { title: "" } }
        expect(response.status).to eq(422) 
      end
    end
  end

  describe "DELETE /destroy" do
    it "カテゴリが削除されること" do
      expect {
        delete category_word_path(category, word)
      }.to change(Word, :count).by(-1)
      expect(response).to redirect_to(category_path(category))
    end
  end

  describe "GET /marked" do 
    context "有効なパラメータの場合" do
      it "word(marked)が表示されること" do 
        FactoryBot.create(:word_mark, word: word, user: user)
        get "/categories/#{category.id}/marked_words"
        expect(response).to have_http_status(200)
        expect(response.body).to include(word.title)
      end
    end
    
    context "無効なパラメータの場合" do
      it "word(marked)が表示されないこと" do
        get "/categories/#{category.id}/marked_words"
        expect(response).to redirect_to(category_path(category))
        follow_redirect!
      end
    end
  end

  describe "POST /share" do 
    let(:group) { FactoryBot.create(:group) }
    context "有効なパラメータの場合" do
      it "wordが共有されること" do 
        post share_category_word_path(category, word), params: { group_ids: [group.id] }
        expect(response).to redirect_to(category_word_path(word.category, word))
        expect(word.group_words.exists?(group_id: group.id)).to be true
      end
    end
  end
end
