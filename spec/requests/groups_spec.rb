require 'rails_helper'

RSpec.describe "Groups", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:group) { FactoryBot.create(:group, user: user) }

  before do
    sign_in user
  end

  describe "GET /groups" do
    it "正常に表示されること" do
      get groups_path
      expect(response.status).to eq(200) 
      expect(response.body).to include(group.group_name)
    end
  end 

  describe "GET /show" do
    it "特定のgroupが表示されること" do
      get group_path(group)
      expect(response.status).to eq(200)
      expect(response.body).to include(group.group_name)
    end
  end

  describe "POST /create" do
    context "有効なパラメータの場合" do
      it "groupを作成しリダイレクトされること" do
        expect {
          post groups_path, params: { group: { group_name: "New Group", group_description: "Description" } }
        }.to change(Group, :count).by(1)
        expect(response).to redirect_to(Group.last)
      end
    end

    context "無効なパラメータの場合" do
      it "groupが作成されずエラーになること" do
        expect {
          post groups_path, params: { group: { group_name: "" } }
        }.not_to change(Group, :count)
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT /update" do
    context "有効なパラメータの場合" do
      it "groupが更新されること" do
        put group_path(group), params: { group: { group_name: "Updated Group" } }
        expect(response).to redirect_to(group)
        expect(group.reload.group_name).to eq("Updated Group")
      end
    end

    context "無効なパラメータの場合" do
      it "groupが更新されずエラーになること" do
        put group_path(group), params: { group: { group_name: "" } }
        expect(response.status).to eq(422)
      end
    end
  end
end