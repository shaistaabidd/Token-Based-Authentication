require "rails_helper"

RSpec.describe PasswordResetMailer, type: :mailer do
    it "should send password reset code on user email" do
        user = create(:user, password_token: "fqaAfg78dhsgu676")
        email = PasswordResetMailer.send_password_reset_email(user).deliver_now
        assert_equal email.to, [user.email]
        assert_equal email.from, ['support@spl.com']
        assert_equal email.subject, 'Password Reset Token!'
        assert_equal email.body, "Hi #{user.name} <br>  <br>your token to reset the password is: #{user.password_token}. Please use this token to reset password.<br>  <br>Regards,<br>  <br>Team System Plus"
    end
end
