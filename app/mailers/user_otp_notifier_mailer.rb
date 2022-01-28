class UserOtpNotifierMailer < ApplicationMailer
    default :from => 'support@spl.com'

    def send_otp_code_on_email(user, otp_code)
        @user = user
        mail( :to => @user.email,
        :subject => 'OTP verification code!',
        :content_type => 'text/html',
        :body => body.html_safe )
    end

    def body
    
        header = "Hi #{@user.name} <br>  <br>"
        message = "your OTP authentication code is: #{@user.test_otp_code}. Please verify your account."
        footer = "<br>  <br>Regards,<br>  <br>Team System Plus"
        header + message + footer
    end
    
end
