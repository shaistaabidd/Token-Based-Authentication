class User < ApplicationRecord
    has_secure_password
    has_one_time_password 
    validates :email, uniqueness: true, presence: true
    validates :phone_number, presence: true
end
