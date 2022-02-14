module Passwords

    class ResetPassword
        include Interactor

        def call
            password_token_present
            find_user_with_token
            if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
                context.message = 'Password changed successfully!'
            else
                context.fail!(message: @user.errors ,status: :unprocessable_entity)
            end
            context.user = @user

        end

        def params
            context.params
        end

        def password_token_present
            if params[:password_token].blank?
                context.fail!(message:'param password_token cannot be null or empty!' ,status: :unprocessable_entity)
            end
        end

        def find_user_with_token
            @user = User.find_by(password_token: params[:password_token])
            unless @user.present?
                context.fail!(message:'Invalid token! Please try again!' ,status: :unprocessable_entity)
            end
        end

    end
end