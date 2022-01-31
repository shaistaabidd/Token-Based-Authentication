class PasswordsController < ApplicationController
    skip_before_action :authenticate_request
    def forgot_password
        if params[:email].blank?
            return render json: {error: 'Email cannot be empty! '}, status: :unprocessable_entity
        else
            user = User.find_by_email(params[:email])

            if user.present?
                token = user.generate_password_token
                send_reset_password_email(user, token)
                render json: {message: 'A password reset token has been sent to your email.'}, status: :ok
            else
                return render json: {error: 'Your account with this email does not exists! Please try again'}, status: :not_found
            end
        
        end
    end

    def reset_password
        if params[:password_token].blank?
            return render json: {error: 'Token cannot be null or empty! '}, status: :unprocessable_entity
        else
            @user = User.find_by(password_token: params[:password_token])
            if @user.present?
                if not password_errors!
                    @user.reset_password!(params[:password])
                    render json: {message: 'Password changed successfully!'}, status: :ok
                end
            else
                return render json: {error: 'Invalid token! Please try again!'}, status: :unprocessable_entity
            end
        end

    end

    private

    def send_reset_password_email(user, token)
        PasswordResetMailer.send_password_reset_email(user, token).deliver_now
    end

    def password_errors!
        if params[:password].blank?
            return render json: {error: 'Password cannot be blank! '}, status: :unprocessable_entity
        else
            if params[:password] != params[:password_confirmation]
                return render json: {error: 'Password confirmation is not matched with your password! '}, status: :unprocessable_entity
            end
        end
    end
    
end
