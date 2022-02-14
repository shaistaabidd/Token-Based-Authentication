class RegisterUser
    prepend SimpleCommand
  
    def initialize(name, email, password, phone_number, company_name, password_confirmation)
        @name = name
        @email = email
        @password = password
        @phone_number = phone_number
        @company_name = company_name
        @password_confirmation = password_confirmation
    end
  
    def call
        if user
            if @password == @password_confirmation
                user = User.create!(name: @name, email: @email, password: @password, phone_number: @phone_number, company_name: @company_name, password_confirmation: @password_confirmation)
                return {token: JsonWebToken.encode(user_id: user.id), user: user}
            else
                return errors.add :error, 'Password confirmation is not matched with your password. '
            end

        end
    end

    private
  
    attr_accessor :email, :password
  
    def user
        
        return errors.add :user_authentication, 'Invalid Credentials! param email, phone_number and password cannot be empty.' if not @email.present? or not @phone_number.present? or not @password.present?
        user = User.find_by_email(email)
        return errors.add :user_authentication, 'User already exists!' if user.present?
        user = User.find_by(phone_number: @phone_number)
        return errors.add :user_authentication, 'Phone number is already taken!' if user.present? and @phone_number == user.phone_number
        true
    end
  
end