require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) } 

  before do
    sign_in user
  end

  describe "POST /create" do
    context "存在するユーザーへ申請できる場合" do
      it "follow申請できること" do
        expect {
          post relationships_path, params: { friend_email: friend.email }
        }.to change(Relationship, :count).by(1)
        
        expect(response.media_type).to eq("text/vnd.turbo-stream.html") 
        expect(response.body).to include(friend.nickname) 
      end
    end

    context "存在しないユーザーへ申請する場合" do
      it "follow申請されずエラーメッセージが返ること" do
        expect {
          post relationships_path, params: { friend_email: "nonexistent@example.com" }
        }.not_to change(Relationship, :count)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:relationship) { user.follow(friend) }

    it "follow申請が削除されること" do
      expect {
        delete relationship_path(friend)
      }.to change(Relationship, :count).by(-1)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("friend_alert") 
      turbo_streams = response.body.scan(/<turbo-stream.*?>/)
      
      expect(turbo_streams.size).to eq(4)
      expect(response.body).to include("friend_list")
      expect(response.body).to include("friend_alert")
      expect(response.body).to include("friend_count")
    end
  end

  describe "POST /search" do
    it "存在するユーザーが検索できること" do
      post search_relationships_path, params: { email: friend.email }
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include(friend.nickname)
    end

    it "存在しないユーザーの場合はエラーが返ること" do
      post search_relationships_path, params: { email: "wrong@example.com" }
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("id=\"search_result\"")
    end
  end
end
