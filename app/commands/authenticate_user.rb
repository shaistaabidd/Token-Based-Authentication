class AuthenticateUser
  prepend SimpleCommand

  def initialize(params)
    @params = params
  end

  def call
    if @params[:user].present?
      if user.present?
        return {token: JsonWebToken.encode(user_id: user.id), user: user}
      end
    else
      return errors.add :user_authentication, 'To sign in to your account, you must pass a hash as an argument. e,g user[name] .' ,status: :unprocessable_entity     
    end
  end


  private

  attr_accessor :email, :password, :otp_code

  def user
    user = User.find_by_email(@params[:user][:email])
    return user if user && user.authenticate(@params[:user][:password])

    errors.add :user_authentication, 'Invalid credentials. Please enter correct email and password.'
    nil
  end

end