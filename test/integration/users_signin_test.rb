require 'test_helper'

class UsersSigninTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:devopsd)
  end
  
  test "login with valid info" do
      post signin_path, params: {
        session: {
          email: @user.email,
          password: "test12"
        }
      }

      assert_response :success
      response = JSON.parse(@response.body)
      assert_equal "Vasya Pupkin", response["user"]["fullname"] 
      assert @response.header["X-BDS-M-AUTH-TOKEN"].length > 0
  end

  test "login with password invalid info" do 
    post signin_path, params: {
        session: {
          email: @user.email,
          password: "test"
        }
      }
    assert_response :unprocessable_entity
    response = JSON.parse(@response.body)
    assert response["errors"].count == 1
  end

  test "login with email invalid" do 
    post signin_path, params: {
        session: {
          email: "wtf@wtf.ru",
          password: "test"
        }
      }
    assert_response :unprocessable_entity
    response = JSON.parse(@response.body)
    assert response["errors"].count == 1
  end
end
