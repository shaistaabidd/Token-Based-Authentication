class RegisterUser
    prepend SimpleCommand
  
    def initialize(params)
        @params = params
    end
  
    def call
        if @params[:user].present?
            if user 
                @user = User.new(user_params)
                if @user.save
                    return {token: JsonWebToken.encode(user_id: @user.id), user: @user}
                else
                    return errors.add :error, @user.errors, status: :unprocessable_entity
                end
            end
        else
            return errors.add :user_authentication, 'To create account, you must pass a hash as an argument. e,g user[name] .' ,status: :unprocessable_entity     
        end
    end

    private
  
    attr_accessor :email, :password
  
    def user
        
        return errors.add :user_authentication, 'Invalid Credentials! param user[email], user[phone_number] and user[password] cannot be empty.' if not @params[:user][:email].present? or not @params[:user][:phone_number].present? or not @params[:user][:password].present?
        user = User.find_by_email(@params[:user][:email])
        return errors.add :user_authentication, 'User already exists!' if user.present?
        user = User.find_by(phone_number: @params[:user][:phone_number])
        return errors.add :user_authentication, 'Phone number is already taken!' if user.present? and @params[:user][:phone_number] == user.phone_number
        true
    end

    def user_params
        @params.require(:user).permit(:name,:email,:phone_number,:company_name,:password,:password_confirmation)
    end
  
end