require 'rails_helper'

RSpec.describe "Friends", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) } 

  before do
    sign_in user
  end
  
  describe "GET /friends" do
    it "works! (now write some real specs)" do
      get friends_index_path
      expect(response).to have_http_status(200)
    end
  end 
end
