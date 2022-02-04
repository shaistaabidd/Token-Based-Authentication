class OtpsController < ApplicationController
    skip_before_action :authenticate_request
    
    def verify_otp
        @result = OtpVerification.call(params: params)
        if @result.success?
            render json: {
                user: { 
                    name: @result.user.name,
                    email: @result.user.email,
                    phone_number: @result.user.phone_number,
                    created_at: @result.user.created_at.strftime("%d-%m-%Y, %z %H:%M:%S"),
                    message: 'Verification successful!',
                    auth_token: @result.token
                }
            }, status: :ok
        else
            render json: { message: @result.message }, status: @result.status
        end
    end

end
