require 'test_helper'

class UsersBodySizingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:devopsd)
  end
  
  test "login and body sizing users with valid info" do
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
      
      post body_sizing_user_path(@user),
        params: {
          user: {
            photo: "https://takprosto.cc/wp-content/uploads/n/novye-standarty-krasoty/1.jpg"
          }
        },
        headers: {
          "X-BDS-M-AUTH-TOKEN": auth_token,
          "X-BDS-M-USER-ID": response_signin["user"]["id"]
        }

      assert_response :success
      # response_user_edit = JSON.parse(@response.body)
      # assert_equal "Vasiliy Pupkevich", response_user_edit["user"]["fullname"]
      # assert_equal 89, response_user_edit["user"]["hips"]
      # assert_equal 90, response_user_edit["user"]["waist"]
      # assert_equal 99, response_user_edit["user"]["chest"]
  end
end
