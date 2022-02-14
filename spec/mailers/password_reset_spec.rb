require "rails_helper"

RSpec.describe PasswordResetMailer, type: :mailer do
    it "should send password reset code on user email" do
        user = create(:user)
        email = PasswordResetMailer.send_password_reset_email(user, 34434).deliver_now
        assert_equal email.to, [user.email]
        assert_equal email.from, ['support@spl.com']
        assert_equal email.subject, 'Password Reset Token!'
    end
end
