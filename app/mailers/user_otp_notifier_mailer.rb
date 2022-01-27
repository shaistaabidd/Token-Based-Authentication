class UserOtpNotifierMailer < ApplicationMailer
    default :from => 'support@spl.com'
    def send_signup_email(user, otp_code)
        @user = user
        mail( :to => @user.email,
        :subject => 'Thanks for signing up for our amazing app',
        :content_type => 'text/html',
        :body => "The OTP code for your request is #{otp_code}" )
    end
end
