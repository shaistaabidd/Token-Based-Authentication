require "rails_helper"

RSpec.describe UserOtpNotifierMailer, type: :mailer do
    it "should send otp code on user email" do
        user = create(:user)
        email = UserOtpNotifierMailer.send_otp_code_on_email(user, 34434).deliver_now
        assert_equal email.to, [user.email]
        assert_equal email.from, ['support@spl.com']
        assert_equal email.subject, 'OTP verification code!'
    end
end
