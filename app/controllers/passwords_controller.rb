class PasswordsController < ApplicationController
    skip_before_action :authenticate_request

    def forgot_password
        @result =  Passwords::ForgotPassword.call(params: params)
        if @result.success?
            render json: { status: @result.message }, status: :ok
        else
            render json: {error: (@result.message)}, status: @result.status
        end
    end

    def reset_password
        @result =  Passwords::ResetPassword.call(params: params)
        if @result.success?
            render json: {
                user: {
                name: @result.user.name,
                email: @result.user.email,
                phone_number: @result.user.phone_number,
                updated_at: @result.user.created_at.strftime("%d-%m-%Y, %z %H:%M:%S"),
                status: @result.message
                }
            },status: :ok
        else
            render json: {error: (@result.message)}, status: @result.status
        end

    end
    
end
