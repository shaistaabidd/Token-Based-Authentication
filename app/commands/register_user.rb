class RegisterUser
    prepend SimpleCommand
  
    def initialize(name, email, password, phone_number, company_name)
        @name = name
        @email = email
        @password = password
        @phone_number = phone_number
        @company_name = company_name
    end
  
    def call
        if not user.present?
            user = User.create!(name: @name, email: @email, password: @password, phone_number: @phone_number, company_name: @company_name)
            JsonWebToken.encode(user_id: user.id)
        end
    end

    private
  
    attr_accessor :email, :password
  
    def user
        user = User.find_by_email(email)
        errors.add :user_authentication, 'User already exists!' if user.present?
        user
    end
  
end