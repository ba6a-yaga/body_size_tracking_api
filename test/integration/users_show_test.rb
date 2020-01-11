require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:devopsd)
  end
  
  test "show user with valid info" do
      post signin_path, 
        params: {
          session: {
            email: @user.email,
            password: "test12"
          }
        }

      assert_response :success
      assert @response.header["X-BDS-M-AUTH-TOKEN"].length > 0
      response_signin = JSON.parse(@response.body)
      assert_equal "Vasya Pupkin", response_signin["user"]["fullname"] 
      assert_equal response_signin["user"]["id"], @user.id
      

      get users_url,
        headers: {
          "X-BDS-M-AUTH-TOKEN": @response.header["X-BDS-M-AUTH-TOKEN"],
          "X-BDS-M-USER-ID": response_signin["user"]["id"]
        }

      assert_response :success
      assert @response.header["X-BDS-M-AUTH-TOKEN"].length > 0
  
  end

  test "show user with invalid token" do
    post signin_path, params: {
      session: {
        email: @user.email,
        password: "test12"
      }
    }
    assert_response :success

    get users_url,  
      params: {
        user: {
          auth_token: "token"
        }
      },
      headers: {
        "X-BDS-M-AUTH-TOKEN": @response.header["INVALID_TOKEN"]
      }

    assert_response :unauthorized
  end

  test "show user with invalid id" do
    post signin_path, params: {
      session: {
        email: @user.email,
        password: "test12"
      }
    }

    assert_response :success
    response_signin = JSON.parse(@response.body)

    @user.id = 171717
    get users_url,
      headers: {
          "X-BDS-M-AUTH-TOKEN": @response.header["INVALID_TOKEN"],
          "X-BDS-M-USER-ID": response_signin["user"]["id"]
      }

    assert_response :unauthorized
  end
end
