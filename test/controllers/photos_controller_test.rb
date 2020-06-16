require 'test_helper'

class PhotosControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get photos_home_url
    assert_response :success
  end

end
