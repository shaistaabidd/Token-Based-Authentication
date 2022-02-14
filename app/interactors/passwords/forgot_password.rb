module Passwords

    class ForgotPassword
        include Interactor

        def call
            if params[:user].present?
                user_present?
                token = @user.generate_password_token
                send_reset_password_email(@user, token)
                context.message = 'A password reset token has been sent to your email.'
            else
                context.fail!(message: 'You must pass a hash as an argument. e,g user[email] .', status: :unprocessable_entity)
            end
        end

        def params
            context.params
        end

        def user_present?
            if params[:user][:email].blank?
                context.fail!(message:'Email cannot be empty!' ,status: :unprocessable_entity)
            else
                @user = User.find_by_email(params[:user][:email])
                unless @user.present?
                    context.fail!(message:'Your account with this email does not exist! Please try again!' , status: :not_found)
                end
            end
        end

        def send_reset_password_email(user, token)
            PasswordResetMailer.send_password_reset_email(user, token).deliver_now
        end
    end
end