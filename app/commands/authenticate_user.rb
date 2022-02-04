class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    if user.present?
      return {token: JsonWebToken.encode(user_id: user.id), user: user}
    end
  end


  private

  attr_accessor :email, :password, :otp_code

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'Invalid credentials. Please enter correct email and password.'
    nil
  end

end