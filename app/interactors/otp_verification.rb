class OtpVerification
    include Interactor

    def call
        if params[:user].present?
            email_or_phone_present?
            @user = user
            user_present?
            verify_otp_code
            context.token = JsonWebToken.encode(user_id: @user.id)
            context.message = "Verification Successful!" 
            context.user = @user
        else
            context.fail!(message: 'To verify otp, you must pass a hash as an argument. e,g user[email] .', status: :unprocessable_entity)
        end
    end

    def params
        context.params
    end

    def user
        return User.find_by_email(params[:user][:email]) if params[:user][:email].present?
        return User.find_by(phone_number: params[:user][:phone_number]) if params[:user][:phone_number].present?
    end

    def email_or_phone_present?
        if params[:user][:email].blank? and params[:user][:phone_number].blank?
            context.fail!(message: 'Email or phone number must be present.', status: :unprocessable_entity)
        end
    end

    def user_present?
        if @user.blank?
            context.fail!(message: 'No such record exists!', status: :not_found)
        end
    end

    def verify_otp_code
        if params[:user][:otp_code].blank?
            context.fail!(message: 'param user[otp_code] cannot be null or empty!', status: :unprocessable_entity)
        elsif user.test_otp_code != params[:user][:otp_code]      
            context.fail!(message: 'otp_code you have entered is incorrect. Please try again!', status: :unprocessable_entity)
        end
    end
end