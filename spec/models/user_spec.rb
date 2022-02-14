require 'rails_helper'
RSpec.describe User, type: :model do
    
    
    it "should not create user with invalid email" do
        user = build(:user, email: nil)
        user.save
        assert_equal(user.errors.messages.length, 1)
        expect(user).to_not be_valid
    end

    it "should not create user with invalid phone" do
        user = build(:user, phone_number: nil)
        user.save
        assert_equal(user.errors.messages.length, 1)
        expect(user).to_not be_valid
    end

    it "should not create user with blank password" do
        user = build(:user, password: nil)
        user.save
        assert_equal(user.errors.messages.length, 1)
        expect(user).to_not be_valid
    end

    it "should not create user with password mismatch" do
        user = build(:user, password: "admin1323", password_confirmation: "admin123")
        user.save
        assert_equal(user.errors.messages.length, 1)
        expect(user).to_not be_valid
    end

    it "should not create user if email or phone number is not unique" do
        user = create(:user)
        duplicate_item = user.dup
        duplicate_item.save
        expect(duplicate_item).to_not be_valid
    end

    it "should create user with valid email, password, password confirmation, phone number" do
        user = create(:user)
        assert_equal(0, user.errors.messages.length)
    end

    it "should have many gigs" do
        t = User.reflect_on_association(:gigs)
        expect(t.macro).to eq(:has_many)
    end

    # context 'associations' do
    #     it { should have_many(:gigs).class_name('Gig') }
    # end

    # it "password mismatch" do
    #     user = build(:user)
    #     user.save!
    #     # expect(user).to_not be_valid
    #     # user.password = 'admin123'
    #     # user.password_confirmation = 'admin1423'
    #     # expect(user).to_not be_valid
    #     # user.password = 'admin123'
    #     # user.password_confirmation = 'admin123'
    #     # expect(user).to be_valid
        
    # end
    # it "must have phone number" do
    #     user = User.new(
    #         name: "kanwal",
    #         email: "kanwal@gmail.com",
    #         password: "admin123",
    #         password_confirmation: "admin123"
    #      )
    #      expect(user).to_not be_valid
    #      user.phone_number = "+18312939015"
    #      expect(user).to be_valid
    # end
    
end
