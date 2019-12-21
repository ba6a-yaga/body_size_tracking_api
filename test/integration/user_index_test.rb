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
        params: {
          user: {
            id: @user.id,
            auth_token: response_signin["token"]
          }
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
      params: {
        user: {
          auth_token: "token"
        }
      }
    assert_response :unauthorized
  end
end
