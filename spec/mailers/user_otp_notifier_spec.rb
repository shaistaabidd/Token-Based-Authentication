require "rails_helper"

RSpec.describe UserOtpNotifierMailer, type: :mailer do
    it "should send otp code on user email" do
        user = create(:user, test_otp_code: 6747)
        email = UserOtpNotifierMailer.send_otp_code_on_email(user).deliver_now
        assert_equal email.to, [user.email]
        assert_equal email.from, ['support@spl.com']
        assert_equal email.subject, 'OTP verification code!'
        assert_equal email.body, "Hi #{user.name} <br>  <br>your OTP authentication code is: #{user.test_otp_code}. Please verify your account.<br>  <br>Regards,<br>  <br>Team System Plus"
    end
end
