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

    response = JSON.parse(@response.body)
    assert_response :unprocessable_entity
    assert response["errors"].count == 2
  end

  test "valid signup info" do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {
        fullname: "Soshnik Petya",
        email: "soshnik@gmail.com",
        password: "test12",
        password_confirmation: "test12" }}
    end
    response = JSON.parse(@response.body)
    assert_equal "soshnik@gmail.com", response["user"]["email"]
    assert response["token"].length > 0
    assert_response :created
  end
end
