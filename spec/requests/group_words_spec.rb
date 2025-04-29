require 'rails_helper'

RSpec.describe "GroupWords", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:group) { FactoryBot.create(:group, user: user) }
  let!(:word) { FactoryBot.create(:word, user: user) }
  let!(:group_word) { FactoryBot.create(:group_word, group: group, word: word, user: user) }

  before do
    sign_in user
  end

  describe "GET /show" do
    it "特定のgroup_wordが表示されること" do
      get group_group_word_path(group_id: group.id, id: group_word.id)
      expect(response.status).to eq(200)
      expect(response.body).to include(word.title)
      expect(response.body).to include(group_word.user.nickname)
    end
  end

  describe "POST /create" do
    context "有効なパラメータの場合" do
      it "group_wordを作成しリダイレクトされること" do
        expect {
          post group_group_words_path(group), params: { word_id: word.id }
        }.to change(GroupWord, :count).by(1)
        expect(response).to redirect_to(group_path(group))
      end
    end

    context "無効なパラメータの場合" do
      it "group_wordが作成されずエラーになること" do
        allow_any_instance_of(GroupWord).to receive(:save).and_return(false)
        expect {
          post group_group_words_path(group), params: { word_id: word.id }
        }.not_to change(GroupWord, :count)
        expect(response.status).to eq(302)
      end
    end
  end
end
