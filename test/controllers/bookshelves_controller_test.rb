require "test_helper"

class BookshelvesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bookshelves_index_url
    assert_response :success
  end
end
