class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
   
    def sign_in
      command = AuthenticateUser.call(params[:email], params[:password])
   
      if command.success?
        render json: { auth_token: command.result }
      else
        render json: { error: command.errors }, status: :unauthorized
      end
    end

    def sign_up
      command = RegisterUser.call(params[:name], params[:email], params[:password], params[:phone_number], params[:company_name])

      if command.success?
          render json: { auth_token: command.result }
      else
          render json: { error: command.errors }, status: :unauthorized
      end
  end
end