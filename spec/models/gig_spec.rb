require 'rails_helper'

RSpec.describe Gig, type: :model do
    it "should belongs to user" do
        t = Gig.reflect_on_association(:user)
        expect(t.macro).to eq(:belongs_to)
    end

    it "should not create gig if user id is nil" do
        gig = build(:gig)
        gig.save
        assert_equal(gig.errors.messages.length, 1)
        expect(gig).to_not be_valid
    end

    it "should not create gig if name is nil" do
        user = create(:user)
        gig = build(:gig, name: nil, user_id: user.id)
        gig.save
        assert_equal(gig.errors.messages.length, 1)
        expect(gig).to_not be_valid
    end

    it "should not create gig if amount is nil" do
        user = create(:user)
        gig = build(:gig, amount: nil, user_id: user.id)
        gig.save
        assert_equal(gig.errors.messages.length, 1)
        expect(gig).to_not be_valid
    end

    it "should not create gig if amount is not a number" do
        user = create(:user)
        gig = build(:gig, amount: "not number", user_id: user.id)
        gig.save
        assert_equal(gig.errors.messages.length, 1)
        expect(gig).to_not be_valid
    end

    it "should create gig if user id, name and amount is valid " do
        user = create(:user)
        gig = create(:gig, user_id: user.id)
        assert_equal(0, gig.errors.messages.length)
        expect(gig).to be_valid
    end

    it "should destroy the gig if user is destroyed" do
        user = create(:user)
        gig = create(:gig, user_id: user.id)
        user.destroy
        assert_equal(user.gigs, [])
    end

end
