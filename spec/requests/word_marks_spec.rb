require 'rails_helper'

RSpec.describe "WordMarks", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user: user) }
  let!(:word) { FactoryBot.create(:word, category: category, user: user) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "正常に表示されること" do
      get word_marks_path
      expect(response.status).to eq(200)
    end
  end

  describe "POST /toggle" do
    context "markが存在しない場合" do
      it "markをONできること" do
        expect {
          post toggle_word_word_marks_path(word), params: { word_id: word.id }
        }.to change(WordMark, :count).by(1)
        expect(response.parsed_body["status"]).to eq("created")
      end
    end

    context "markが存在する場合" do
      before do
        FactoryBot.create(:word_mark, word: word, user: user, review_date: Date.today)
      end

      it "markをOFFできること" do
        expect {
          post toggle_word_word_marks_path(word), params: { word_id: word.id }
        }.to change(WordMark, :count).by(-1)
        expect(response.parsed_body["status"]).to eq("deleted")
      end
    end
  end

  describe "POST /update_review_date" do
    let!(:word_mark) { FactoryBot.create(:word_mark, word: word, user: user, review_date: Date.today) }

    it "間違えた場合にreview_dateが更新されること" do
      post update_review_date_word_marks_path, params: { word_id: word.id, wrong: true }
      expect(response.parsed_body["success"]).to be true
      expect(word.reload.word_marks.first.review_date).to eq(Time.zone.today + 3.days)
    end
  end
end