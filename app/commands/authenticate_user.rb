class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    if user.present?
      generate_otp_code
      send_otp_code_on_sms
      UserOtpNotifierMailer.send_otp_code_on_email(user, @otp_code).deliver_now
      'An activation code would be sent to your email and phone number.'
    end
  end


  private

  attr_accessor :email, :password, :otp_code

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end

  def generate_otp_code
    @otp_code = user.otp_code
    user.update(test_otp_code: otp_code)
    @otp_code
  end

  def send_otp_code_on_sms
    client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])

      client.api.account.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: '+18312939010',
      body: body 
      )

    rescue Twilio::REST::RestError
      errors.add :user_authentication, 'yayyyyyyy'  
  end

  def body
    header = "Hi #{user.name}\n\n"
    message = "your OTP authentication code is: #{user.test_otp_code}. Please verify your account."
    footer = "\n\nRegards,\nTeam System Plus."
    header + message + footer
  end
end