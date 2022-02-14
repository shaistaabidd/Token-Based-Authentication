class PasswordResetMailer < ApplicationMailer
    default :from => 'support@spl.com'

    def send_password_reset_email(user)
        @user = user
        mail( :to => @user.email,
        :subject => 'Password Reset Token!',
        :content_type => 'text/html',
        :body => body.html_safe )
    end

    def body
        header = "Hi #{@user.name} <br>  <br>"
        message = "your token to reset the password is: #{@user.password_token}. Please use this token to reset password."
        footer = "<br>  <br>Regards,<br>  <br>Team System Plus"
        header + message + footer
    end

end
