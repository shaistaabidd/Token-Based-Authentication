class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
   
    def sign_in
      command = AuthenticateUser.call(params[:email], params[:password])
   
      if command.success?
        render json: { message: command.result }
      else
        render json: { error: command.errors }, status: :unauthorized
      end
    end

    def sign_up
      command = RegisterUser.call(params[:name], params[:email], params[:password], params[:phone_number], params[:company_name], params[:password_confirmation])

      if command.success?
          render json: { user: User.find_by_email(params[:email]), auth_token: command.result }
      else
          render json: { error: command.errors }, status: :bad_request
      end
    end

    def verify_otp
      if user
        if verify_code?
          generate_json_web_token
        else
          render json: { message: 'OTP code must be valid!' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Email or phone number must be present.' }, status: :unprocessable_entity
      end
    end

    private
  
    attr_accessor :email, :password
  
    def user
      return User.find_by_email(params[:email]) if params[:email].present?
      return User.find_by(phone_number: params[:phone_number]) if params[:phone_number].present?
    end

    def generate_json_web_token
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        user: user,
        message: 'Verification successful!',
        auth_token: token
      }, status: :created
    end
  
    def verify_code?
      user.test_otp_code == params[:otp_code] if user.present?
    end
end