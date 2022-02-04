class OtpVerification
    include Interactor

    def call
        email_or_phone_present?
        @user = user
        user_present?
        verify_otp_code
        context.token = JsonWebToken.encode(user_id: @user.id)
        context.message = "Verification Successful!" 
        context.user = @user
    end

    def params
        context.params
    end

    def user
        return User.find_by_email(params[:email]) if params[:email].present?
        return User.find_by(phone_number: params[:phone_number]) if params[:phone_number].present?
    end

    def email_or_phone_present?
        if params[:email].blank? and params[:phone_number].blank?
            context.fail!(message: 'Email or phone number must be present.', status: :unprocessable_entity)
        end
    end

    def user_present?
        if @user.blank?
            context.fail!(message: 'No such record exists!', status: :not_found)
        end
    end

    def verify_otp_code
        p user.test_otp_code
        p params[:otp_code]
        if params[:otp_code].blank?
            context.fail!(message: 'param otp_code cannot be null or empty!', status: :unprocessable_entity)
        elsif user.test_otp_code != params[:otp_code]      
            context.fail!(message: 'otp_code you have entered is incorrect. Please try again!', status: :unprocessable_entity)
        end
    end
end