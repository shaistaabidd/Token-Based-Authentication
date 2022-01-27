class AuthenticateUser
    prepend SimpleCommand
  
    def initialize(email, password)
      @email = email
      @password = password
    end
  
    def call
      if user.present?
        send_code
        otp_code = user.otp_code
        user.update(test_otp_code: otp_code)
        UserOtpNotifierMailer.send_signup_email(user,otp_code).deliver_now
        'An activation code would be sent to your email and phone number.'
      end
    end

  
    private
  
    attr_accessor :email, :password
  
    def user
      user = User.find_by_email(email)
      return user if user && user.authenticate(password)
  
      errors.add :user_authentication, 'invalid credentials'
      nil
    end

    def send_code
      response = VerificationService.new(
        user.phone_number,
    ).send_otp_code

      response
    end
end