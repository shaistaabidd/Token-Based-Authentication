class User < ApplicationRecord
    has_secure_password
    has_one_time_password 
    has_many :gigs, dependent: :destroy
    validates :email, presence: :ture, uniqueness: :true
    validates :phone_number, presence: :ture, uniqueness: :true
    validate :password_match, :if => Proc.new { |user| user.password_digest_changed?}
    def generate_password_token
        token = SecureRandom.hex(10)
        self.password_token = token
        save!
        token
    end

    def reset_password!(password)
        update(password: password)
    end

    def password_match
        if password.present? and password_confirmation.blank?
            errors.add("password mismatch", "Password confirmation is not matched with your password.")
        end
    end
end
