require 'rails_helper'

RSpec.describe "Uploaders", type: :request do

  describe "GET /image" do
    it "returns http success" do
      get "/uploader/image"
      expect(response).to have_http_status(:success)
    end
  end

end
