class RegisterUser
    prepend SimpleCommand
  
    def initialize(params)
        @params = params
    end
  
    def call
        if @params[:user].present?
            @user = User.new(user_params)
            if @user.save
                return {token: JsonWebToken.encode(user_id: @user.id), user: @user}
            else
                return errors.add :error, @user.errors, status: :unprocessable_entity
            end
        else
            return errors.add :user_authentication, 'To create account, you must pass a hash as an argument. e,g user[name] .' ,status: :unprocessable_entity     
        end
    end

    private
  
    attr_accessor :email, :password

    def user_params
        @params.require(:user).permit(:name,:email,:phone_number,:company_name,:password,:password_confirmation)
    end
  
end