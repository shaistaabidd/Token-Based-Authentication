require 'rails_helper'

RSpec.describe "Gigs", type: :request do

    it "should return response ok on gig created successfully" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = build(:gig, user_id: user.id)
        post "/gigs", headers: { 'Authorization' => token },
          params: { gig: { name: gig.name, amount: gig.amount } }
          expect(response.status).to eq 200
          expect(response.message).to eq "OK"
          payload = JSON.parse(response.body)
          expect(payload["gig"]["status"]).to eq "Gig is saved Successfully!"
          expect(payload["gig"]["name"]).to eq gig.name
          expect(payload["gig"]["user_id"]).to eq gig.user_id
    end

    it "should return response Unprocessable Entity if name is nil on create gig" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        post "/gigs", headers: { 'Authorization' => token },
          params: { gig: { name: nil, amount: gig.amount } }
          expect(response.status).to eq 422
          expect(response.message).to eq "Unprocessable Entity"
          payload = JSON.parse(response.body)
          assert_equal(payload["error"]["name"], ["can't be blank"])
    end

    it "should return response Unprocessable Entity if amount is nil or invalid on create gig" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        post "/gigs", headers: { 'Authorization' => token },
          params: { gig: { name: gig.name, amount: nil } }
          expect(response.status).to eq 422
          expect(response.message).to eq "Unprocessable Entity"
          payload = JSON.parse(response.body)
          assert_equal(payload["error"]["amount"], ["can't be blank", "is not a number"])
    end

    it "should return response ok on gig updated successfully" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        patch "/gigs/#{gig.id}", headers: { 'Authorization' => token },
          params: { gig: { name: "new gig", amount: gig.amount } }
          payload = JSON.parse(response.body)
          gig.reload
          expect(response.status).to eq 200
          expect(response.message).to eq "OK"
          expect(payload["gig"]["status"]).to eq "Gig is updated Successfully!"
          expect(payload["gig"]["name"]).to eq gig.name
          expect(payload["gig"]["user_id"]).to eq gig.user_id
    end

    it "should return response Unprocessable Entity if name is nil on gig update" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        patch "/gigs/#{gig.id}", headers: { 'Authorization' => token },
          params: { gig: { name: nil, amount: gig.amount } }
          payload = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(response.message).to eq "Unprocessable Entity"
          expect(payload["error"]["name"]).to eq ["can't be blank"]
    end

    it "should return response Unprocessable Entity if amount is nil or invalid on gig update" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        patch "/gigs/#{gig.id}", headers: { 'Authorization' => token },
          params: { gig: { name: gig.name, amount: nil } }
          payload = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(response.message).to eq "Unprocessable Entity"
          expect(payload["error"]["amount"]).to eq ["can't be blank", "is not a number"]
    end

    it "should return response Unprocessable Entity if user id is nil on gig update" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        patch "/gigs/#{gig.id}", headers: { 'Authorization' => token },
          params: { gig: { name: gig.name, amount: gig.amount, user_id: nil } }
          payload = JSON.parse(response.body)
          expect(response.status).to eq 422
          expect(response.message).to eq "Unprocessable Entity"
          expect(payload["error"]["user"]).to eq ["must exist"]
    end

    it "should return not authorized if auth token is not provided on create gig" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        post "/gigs", headers: { 'Authorization' => nil },
          params: { gig: { name: nil, amount: gig.amount } }
          expect(response.status).to eq 401
          expect(response.message).to eq "Unauthorized"
          payload = JSON.parse(response.body)
          assert_equal(payload["error"], "Not Authorized.")
    end

    it "should return not authorized if auth token is not provided on update gig" do
        user = create(:user)
        payload = {:user_id => user.id, :exp => (24.hours.from_now).to_i}
        token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
        gig = create(:gig, user_id: user.id)
        patch "/gigs/#{gig.id}", headers: { 'Authorization' => nil },
          params: { gig: { name: nil, amount: gig.amount } }
          expect(response.status).to eq 401
          expect(response.message).to eq "Unauthorized"
          payload = JSON.parse(response.body)
          assert_equal(payload["error"], "Not Authorized.")
    end
    

    
    

end
