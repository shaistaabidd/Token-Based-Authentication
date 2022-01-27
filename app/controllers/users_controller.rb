class UsersController < ApplicationController

  skip_before_action :authenticate_request, :only => [ :verify_otp]

  def update
    if current_user.update(name: params[:name], email: params[:email], password: params[:password], phone_number: params[:phone_number], company_name: params[:company_name])
      render json: { success: "Profile Updated Successfully!" }
    else
      render json: { error: "Something went wrong. Please try again." }, status: :unauthorized
    end
  end

  def verify_otp

    if user.present?
      if verify_sms_otp_code? 
        generate_json_web_token
      else
        render json: { data: {}, message: 'OTP code must be valid!' },
          status: :unprocessable_entity
      end
    else
      render json: {
        message: 'Email or phone number must be present.'
      }, status: :unprocessable_entity
    end

    rescue Twilio::REST::RestError
      if user
        if verify_email_otp?
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
        phone_number: user.phone_number,
        message: 'Verification successful!',
        auth_token: token
      }, status: :created
    end

    def verify_sms_otp_code?
      VerificationService.new(
        user.phone_number,
      ).verify_otp_code?(params['otp_code'])
    end
  
    def verify_email_otp?
      user.test_otp_code == params[:otp_code] if user.present?
    end


end
