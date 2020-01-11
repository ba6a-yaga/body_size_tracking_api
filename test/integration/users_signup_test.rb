require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup info" do
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {
        fullname: "Soshnik Petya",
        email: "soshnik@gmail.com",
        password: "test",
        password_confirmation: "test1" }}
    end

    assert_response :unprocessable_entity
    response = JSON.parse(@response.body)
    assert response["errors"].count == 2
  end

  test "valid signup info" do
    assert_difference 'User.count', 1 do
      post signup_path, 
        params: { 
          user: {
            fullname: "Soshnik Petya",
            email: "soshnik@gmail.com",
            password: "test12",
            password_confirmation: "test12" 
          }
      }
    end

    assert_response :created
    assert @response.header["X-BDS-M-AUTH-TOKEN"].length > 0
    response_signin = JSON.parse(@response.body)
    assert_equal "soshnik@gmail.com", response_signin["user"]["email"]
  end
end
