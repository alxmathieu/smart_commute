require 'test_helper'

class ItinerariesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get itineraries_new_url
    assert_response :success
  end

  test "should get create" do
    get itineraries_create_url
    assert_response :success
  end

end
