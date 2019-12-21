require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:devopsd)
  end
  
  test "show user with valid info" do
      post signin_path, params: {
        session: {
          email: @user.email,
          password: "test12"
        }
      }
      response_signin = JSON.parse(@response.body)
      assert_equal "Vasya Pupkin", response_signin["user"]["fullname"] 
      assert response_signin["token"].length > 0
      assert_equal response_signin["user"]["id"], @user.id
      assert_response :success

      get user_url(@user),  
        params: {
          user: {
            auth_token: response_signin["token"]
          }
        }
      response_show = JSON.parse(@response.body)
      assert response_show["token"].length > 0
      assert_response :success
  end

  test "show user with invalid token" do
    post signin_path, params: {
      session: {
        email: @user.email,
        password: "test12"
      }
    }
    assert_response :success

    get user_url(@user),  
      params: {
        user: {
          auth_token: "token"
        }
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
    response = JSON.parse(@response.body)

    @user.id = 171717
    get user_url(@user),  
      params: {
        user: {
          auth_token: response["token"]
        }
      }
    assert_response :unauthorized
  end
end
