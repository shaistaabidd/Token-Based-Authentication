require 'rails_helper'
require 'factory/users'
RSpec.describe UsersController, type: :request do
  # it 'should send otp code to user phone number' do
  #   user = build(:user)
  #   post '/send_otp_code', params: {user: {phone_number: user.phone_number}}
  #   payload = JSON.parse(response.body)

  #   expect(response.status).to eq 200
  #   expect(payload["message"]).to eq("An activation code would be sent to your phonenumber!")
  #   expect(payload["phone_number"]).to eq user.phone_number.to_s
  # end

  # it 'should create a new verified user' do
  #   user = build(:user)
  #   post '/users', params: {user: {phone_number: user.phone_number, otp_code: "123456"}}
  #   payload = JSON.parse(response.body)
  #   auth_token = payload["auth_token"]
  #   user_token = JsonWebToken.decode(auth_token)

  #   expect(response.status).to eq 201
  #   expect(payload["user"]["phone_number"]).to eq(user.phone_number)
  #   expect(user_token["user_id"]).to eq(User.first.id)
  #   expect(payload["message"]).to eq "Phone number verified!"
  # end
  it "should return response ok on successfull sign up" do
    user = build(:user)
    post "/sign_up",
      params: { user: { name: user.name, email: user.email, phone_number: user.phone_number, password: 'admin123', password_confirmation: 'admin123' } }
      expect(response.status).to eq 200
      expect(response.message).to eq "OK"
      payload = JSON.parse(response.body)
      expect(payload["user"]["status"]).to eq "Profile is created successfully!"
      expect(payload["user"]["name"]).to eq user.name
      expect(payload["user"]["email"]).to eq user.email
      expect(payload["user"]["phone_number"]).to eq user.phone_number
      expect(payload["user"]["auth_token"]).to be_present
  end

  it "should return response unprocessable entity on sign up if email or phone already exists" do
    user = create(:user)
    post "/sign_up",
      params: { user: { name: user.name, email: user.email, phone_number: user.phone_number, password: 'admin123', password_confirmation: 'admin123' } }
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      payload = JSON.parse(response.body)
      assert_equal(payload["error"].length, 1) 
  end

  it "should return response unprocessable entity if email, phone or password are invalid" do
    user = build(:user)
    post "/sign_up",
      params: { user: { name: user.name, email: nil, phone_number: nil, password: nil, password_confirmation: 'admin123' } }
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      payload = JSON.parse(response.body)
      assert_equal(payload["error"].length,1)
      assert_nil(payload["user"])
  end

  it "should return response ok on successful authentication " do
    user = create(:user)
    post "/sign_in",
      params: { user: { email: user.email, password: user.password } }
      expect(response.status).to eq 200
      expect(response.message).to eq "OK"
      payload = JSON.parse(response.body)
      expect(payload["user"]["status"]).to eq "Login successfull!"
      expect(payload["user"]["name"]).to eq user.name
      expect(payload["user"]["email"]).to eq user.email
      expect(payload["user"]["phone_number"]).to eq user.phone_number
      expect(payload["user"]["auth_token"]).to be_present
  end

  it "should return response unprocessable entity on login failed " do
    user = create(:user)
    post "/sign_in",
      params: { user: { email: "shaista@systemplus.co", password: user.password } }
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      payload = JSON.parse(response.body)
      assert_equal(payload["error"].length,1)
      assert_nil(payload["user"])
  end

  it "should return response unprocessable entity on otp login failed " do
    user = create(:user)
    post "/otp_sign_in",
      params: { user: { email: "shaista@systemplus.co", password: user.password } }
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      payload = JSON.parse(response.body)
      assert_equal(payload["error"].length,1)
      assert_nil(payload["user"])
  end

  it "should return response ok on otp login successfull " do
    user = create(:user)
    post "/otp_sign_in",
      params: { user: { email: user.email, password: user.password } }
      expect(response.status).to eq 200
      payload = JSON.parse(response.body)
      expect(payload["message"]).to eq "An activation code would be sent to your email and phone number."
  end

  it "should return response ok on verify otp " do
    user = create(:user, test_otp_code: 123456)
    post "/verify_otp",
      params: { user: { email: user.email, otp_code: user.test_otp_code } }
      expect(response.status).to eq 200
      payload = JSON.parse(response.body)
      expect(payload["user"]["message"]).to eq "Verification successful!"
      expect(payload["user"]["name"]).to eq user.name
      expect(payload["user"]["email"]).to eq user.email
      expect(payload["user"]["phone_number"]).to eq user.phone_number
      expect(payload["user"]["auth_token"]).to be_present
  end

  it "should return response Unprocessable Entity if phone number or email is empty on verify otp" do
    user = create(:user, test_otp_code: 123456)
    post "/verify_otp",
      params: { user: { email: nil, otp_code: user.test_otp_code } }
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      payload = JSON.parse(response.body)
      expect(payload["message"]).to eq "Email or phone number must be present."
  end

  it "should return response record not found if phone number or email doesn't exist on verify otp" do
    user = create(:user, test_otp_code: 123456)
    post "/verify_otp",
      params: { user: { email: 'abc@gmail.com', otp_code: user.test_otp_code } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 404
      expect(response.message).to eq "Not Found"
      expect(payload["message"]).to eq "No such record exists!"
  end

  it "should return response Unprocessable Entity if otp_code is invalid on verify otp" do
    user = create(:user, test_otp_code: 123456)
    post "/verify_otp",
      params: { user: { email: user.email, otp_code: 564446 } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      expect(payload["message"]).to eq "otp_code you have entered is incorrect. Please try again!"
  end

  it "should return response Unprocessable Entity if otp_code is empty on verify otp" do
    user = create(:user, test_otp_code: 123456)
    post "/verify_otp",
      params: { user: { email: user.email, otp_code: nil } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      expect(payload["message"]).to eq "param user[otp_code] cannot be null or empty!"
  end

  it "should return response Unprocessable Entity if email is blank on forgot password" do
    user = create(:user)
    post "/forgot_password",
      params: { user: { email: nil } }
      payload = JSON.parse(response.body)
      expect(payload["error"]).to eq "Email cannot be empty!"
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
  end

  it "should return response record not found if email doesn't exist on forgot password" do
    user = create(:user)
    post "/forgot_password",
      params: { user: { email: 'abc@gmail.com' } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 404
      expect(response.message).to eq "Not Found"
      expect(payload["error"]).to eq "Your account with this email does not exist! Please try again!"
  end

  it "should return ok if email is valid on forgot password" do
    user = create(:user)
    post "/forgot_password",
      params: { user: { email: user.email } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.message).to eq "OK"
      expect(payload["status"]).to eq "A password reset token has been sent to your email."
  end

  it "should return response ok if password token and new password is valid on reset password" do
    user = create(:user, password_token: 234355)
    post "/reset_password",
      params: { user: { password_token: user.password_token, password: user.password, password_confirmation: user.password_confirmation } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.message).to eq "OK"
      expect(payload["user"]["status"]).to eq "Password changed successfully!"
      expect(payload["user"]["name"]).to eq user.name
      expect(payload["user"]["email"]).to eq user.email
      expect(payload["user"]["phone_number"]).to eq user.phone_number
  end

  it "should return response Unprocessable Entity if password token is nil on reset password" do
    user = create(:user, password_token: 234355)
    post "/reset_password",
      params: { user: { password_token: nil } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      expect(payload["error"]).to eq "param password_token cannot be null or empty!"
  end

  it "should return response Unprocessable Entity if password token is invalid on reset password" do
    user = create(:user, password_token: 234355)
    post "/reset_password",
      params: { user: { password_token: 873276 } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      expect(payload["error"]).to eq "Invalid token! Please try again!"
  end

  it "should return response Unprocessable Entity if password is nil on reset password" do
    user = create(:user, password_token: 234355)
    post "/reset_password",
      params: { user: { password_token: user.password_token, password: nil } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      assert_equal(payload["error"].length,1)
      assert_equal(payload["error"]["password"],["can't be blank"])
  end

  it "should return response Unprocessable Entity if password is not matched with password confirmation on reset password" do
    user = create(:user, password_token: 234355)
    post "/reset_password",
      params: { user: { password_token: user.password_token, password: "abc", password_confirmation: "def" } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.message).to eq "Unprocessable Entity"
      assert_equal(payload["error"].length,1)
      assert_equal(payload["error"]["password_confirmation"],["doesn't match Password"])
  end

  it "should return response Ok if user profile is updated successfully" do
    user = create(:user)
    payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
    token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
    patch "/update",headers: { 'Authorization' => token },
      params: { user: { name: "Hina", password: "abc", password_confirmation: "abc" } }
      payload = JSON.parse(response.body)
      user.reload
      expect(response.status).to eq 200
      expect(response.message).to eq "OK"
      expect(payload["user"]["name"]).to eq user.name
      expect(payload["user"]["email"]).to eq user.email
      expect(payload["user"]["phone_number"]).to eq user.phone_number
      expect(payload["user"]["status"]).to eq "Profile Updated Successfully!"
  end

  it "should return response Unauthorized if bearer token is nil to update profile" do
    user = create(:user)
    payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
    token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
    patch "/update",headers: { 'Authorization' => nil },
      params: { user: { name: "Hina", password: "abc", password_confirmation: "abc" } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 401
      expect(response.message).to eq "Unauthorized"
      expect(payload["error"]).to eq "Not Authorized."
  end

  it "should return response Unprocessable Entity if password is not matched with password confirmation to update profile" do
    user = create(:user)
    payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
    token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
    patch "/update",headers: { 'Authorization' => token },
      params: { user: { name: "Hina", password: "abc", password_confirmation: "acbc" } }
      payload = JSON.parse(response.body)
      expect(response.status).to eq 422
      expect(response.message).to eq 'Unprocessable Entity'
      expect(payload["error"]["password_confirmation"]).to eq ["doesn't match Password"]
  end

  

  



  # it "should login into account" do
  #   user = build(:user, password: "admin123", password_confirmation: "admin123")
  #   post "/sign_up",
  #     params: { user: { name: user.name, email: user.email, phone_number: user.phone_number, password: 'admin123', password_confirmation: 'admin123' } }
  #     expect(response.status).to eq 200
  #     expect(response.message).to eq "OK"
  #     payload = JSON.parse(response.body)
  #     expect(payload["user"]["status"]).to eq "Profile is created successfully!"
  #     expect(payload["user"]["name"]).to eq user.name
  #     expect(payload["user"]["email"]).to eq user.email
  #     expect(payload["user"]["phone_number"]).to eq user.phone_number
  #     expect(payload["user"]["auth_token"]).to be_present
  # end

end