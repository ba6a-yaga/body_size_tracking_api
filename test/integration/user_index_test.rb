require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:devopsd)
  end
  
  test "show my user with valid info" do
      post signin_path, params: {
        session: {
          email: @user.email,
          password: "test12"
        }
      }
      assert_response :success
      response_signin = JSON.parse(@response.body)
      
      get my_path, 
        headers: {
          "X-BDS-M-AUTH-TOKEN": @response.header["X-BDS-M-AUTH-TOKEN"],
          "X-BDS-M-USER-ID": response_signin["user"]["id"]
        }

        
      assert_response :success
  end

  test "show my user with invalid token" do
    post signin_path, params: {
      session: {
        email: @user.email,
        password: "test12"
      }
    }
    assert_response :success

    get my_path,  
      headers: {"X-BDS-M-AUTH-TOKEN": "INVALID_TOKEN"}

    assert_response :unauthorized
  end
end
