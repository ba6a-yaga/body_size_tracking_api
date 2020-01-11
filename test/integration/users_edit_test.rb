require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:devopsd)
  end
  
  test "login and edit users with valid info" do
      post signin_path, 
        params: {
          session: {
            email: @user.email,
            password: "test12"
          }
        }

      assert_response :success
      auth_token = @response.header["X-BDS-M-AUTH-TOKEN"]
      assert auth_token.length > 0
      response_signin = JSON.parse(@response.body)
      assert_equal "Vasya Pupkin", response_signin["user"]["fullname"] 
      assert response_signin["user"]["id"] > 0
      
      post user_url(@user), 
        params: {
          user: {
            fullname: "Vasiliy Pupkevich",
            waist: 90,
            hips: 89,
            chest: 99
          }
        },
        headers: {
          "X-BDS-M-AUTH-TOKEN": auth_token,
          "X-BDS-M-USER-ID": response_signin["user"]["id"]
        }

      assert_response :success
      response_user_edit = JSON.parse(@response.body)
      assert_equal "Vasiliy Pupkevich", response_user_edit["user"]["fullname"]
      assert_equal 89, response_user_edit["user"]["hips"]
      assert_equal 90, response_user_edit["user"]["waist"]
      assert_equal 99, response_user_edit["user"]["chest"]
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
          hips: 90
        }
      },
      headers: {
        "X-BDS-M-AUTH-TOKEN": "INVALID_TOKEN"
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

    assert_response :success
    response_signin = JSON.parse(@response.body)
    
    post user_url(@user),  
      params: {
        user: {
          fullname: "Vasiliy Pupkevich",
          waist: 500,
          hips: 500,
          chest: 500
        }
      },
      headers: {
        "X-BDS-M-AUTH-TOKEN": @response.header["X-BDS-M-AUTH-TOKEN"],
        "X-BDS-M-USER-ID": response_signin["user"]["id"]
      }
    
    assert_response :unprocessable_entity
    response_edit = JSON.parse(@response.body)
    assert response_edit["errors"].count == 3
  end
end
