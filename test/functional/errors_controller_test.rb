require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "should get bad_route" do
    get :bad_route
    assert_response :success
  end

end
