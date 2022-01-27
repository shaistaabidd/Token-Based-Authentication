require 'rails_helper'
require 'factory/users'
RSpec.describe UsersController, type: :request do
  it 'should send otp code to user phone number' do
    user = build(:user)
    post '/send_otp_code', params: {user: {phone_number: user.phone_number}}
    payload = JSON.parse(response.body)

    expect(response.status).to eq 200
    expect(payload["message"]).to eq("An activation code would be sent to your phonenumber!")
    expect(payload["phone_number"]).to eq user.phone_number.to_s
  end

  it 'should create a new verified user' do
    user = build(:user)
    post '/users', params: {user: {phone_number: user.phone_number, otp_code: "123456"}}
    payload = JSON.parse(response.body)
    auth_token = payload["auth_token"]
    user_token = JsonWebToken.decode(auth_token)

    expect(response.status).to eq 201
    expect(payload["user"]["phone_number"]).to eq(user.phone_number)
    expect(user_token["user_id"]).to eq(User.first.id)
    expect(payload["message"]).to eq "Phone number verified!"
  end
end