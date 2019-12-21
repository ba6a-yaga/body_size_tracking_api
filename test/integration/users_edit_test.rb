require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:devopsd)
  end
  
  test "login and edit users with valid info" do
      post signin_path, params: {
        session: {
          email: @user.email,
          password: "test12"
        }
      }
      response_signin = JSON.parse(@response.body)
      assert_equal "Vasya Pupkin", response_signin["user"]["fullname"] 
      assert response_signin["token"].length > 0
      assert response_signin["user"]["id"] > 0
      assert_response :success
      
      patch user_url(@user),  
        params: {
          user: {
            fullname: "Vasiliy Pupkevich",
            hips: 90,
            waist: 89,
            chest: 88,
            auth_token: response_signin["token"]
          }
        }
      response_user_edit = JSON.parse(@response.body)
      assert_equal "Vasiliy Pupkevich", response_user_edit["user"]["fullname"]
      assert_equal 90, response_user_edit["user"]["hips"]
      assert_response :success
  end

  test "login and edit users with invalid token" do
    post signin_path, params: {
      session: {
        email: @user.email,
        password: "test12"
      }
    }
    assert_response :success
    
    patch user_url(@user),  
      params: {
        user: {
          fullname: "Vasiliy Pupkevich",
          hips: 90,
          auth_token: "token"
        }
      }
    assert_response :unauthorized
  end

  test "login and edit users with invalid info" do
    post signin_path, params: {
      session: {
        email: @user.email,
        password: "test12"
      }
    }
    response_signin = JSON.parse(@response.body)
    assert_response :success
    
    patch user_url(@user),  
      params: {
        user: {
          fullname: "Vasiliy Pupkevich",
          waist: 500,
          hips: 500,
          chest: 500,
          auth_token: response_signin["token"]
        }
      }
    assert_response :unprocessable_entity
    response_edit = JSON.parse(@response.body)
    assert response_edit["errors"].count == 3
  end
end
