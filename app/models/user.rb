class User < ApplicationRecord
    has_secure_password
    has_one_time_password 
    has_many :gigs, dependent: :destroy

    def generate_password_token
        token = SecureRandom.hex(10)
        self.password_token = token
        save!
        token
    end

    def reset_password!(password)
        update(password: password)
    end
end
