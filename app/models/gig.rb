class Gig < ApplicationRecord
    belongs_to :user
    validates :name, presence: :true
    validates :amount, presence: :true , numericality: true
end
