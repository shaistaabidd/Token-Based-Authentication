class OtpSignin
    prepend SimpleCommand
  
    def initialize(params)
      @params = params
    end
  
    def call
      if @params[:user].present?
        if user.present?
          generate_otp_code
          send_otp_code_on_sms
          UserOtpNotifierMailer.send_otp_code_on_email(user).deliver_now
          'An activation code would be sent to your email and phone number.'
        end
      else
        return errors.add :user_authentication, 'To sign in to your account, you must pass a hash as an argument. e,g user[name] .' ,status: :unprocessable_entity     
      end
    end
  
  
    private
  
    attr_accessor :email, :password, :otp_code
  
    def user
      user = User.find_by_email(@params[:user][:email])
      return user if user && user.authenticate(@params[:user][:password])
  
      errors.add :user_authentication, 'Invalid credentials. Please enter correct email and password.'
      nil
    end
  
    def generate_otp_code
      @otp_code = user.otp_code
      user.update(test_otp_code: @otp_code)
      @otp_code
    end
  
    def send_otp_code_on_sms
      @client = FakeTwilio.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN']).send_message(user)
    end
  
  end