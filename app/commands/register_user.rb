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

        if user
            user = User.create!(name: @name, email: @email, password: @password, phone_number: @phone_number, company_name: @company_name)
            JsonWebToken.encode(user_id: user.id)
        end
    end

    private
  
    attr_accessor :email, :password
  
    def user
        return errors.add :user_authentication, 'Invalid Credentials! Email, Phone Number and Password could not be empty.' if not @email.present? or not @phone_number.present? or not @password.present?
        user = User.find_by_email(email)
        return errors.add :user_authentication, 'User already exists!' if user.present?
        user = User.find_by(phone_number: @phone_number)
        return errors.add :user_authentication, 'Phone number is already taken!' if user.present? and @phone_number == user.phone_number
        true
    end
  
end