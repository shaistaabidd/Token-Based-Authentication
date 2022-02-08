class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    def otp_sign_in
      command = OtpSignin.call(params[:email], params[:password])
   
      if command.success?
        render json: { message: command.result }
      else
        render json: { error: command.errors }, status: :unprocessable_entity
      end

    end
   
    def sign_in
      command = AuthenticateUser.call(params[:email], params[:password])
   
      if command.success?
        render json: {
          user: { 
            name: command.result[:user].name,
            email: command.result[:user].email,
            phone_number: command.result[:user].phone_number,
            created_at: command.result[:user].created_at.strftime("%d-%m-%Y, %z %H:%M:%S"),
            status: "Login successfull!",
            auth_token: command.result[:token] 
          }
        }
      else
        render json: { error: command.errors }, status: :unprocessable_entity
      end
    end

    def sign_up
      command = RegisterUser.call(params)

      if command.success?
        render json: {
          user: { 
            name: command.result[:user].name,
            email: command.result[:user].email,
            phone_number: command.result[:user].phone_number,
            created_at: command.result[:user].created_at.strftime("%d-%m-%Y, %z %H:%M:%S"),
            status: "Profile is created successfully!",
            auth_token: command.result[:token] 
          }
        }
      else
        render json: { error: command.errors }, status: :unprocessable_entity
      end
    end


end