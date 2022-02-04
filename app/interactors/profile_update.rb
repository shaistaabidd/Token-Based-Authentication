class ProfileUpdate
  include Interactor

  def call
    user_params
    if current_user.update(user_params)
      context.message = "Profile Updated Successfully!" 
    else
      context.fail!(message: current_user.errors,status: :unprocessable_entity)
    end
    context.user = current_user
  end

  def params
    context.params
  end

  def current_user
    context.current_user
  end

  def user_params
    if not params[:user].present?
      context.fail!(message:'To update profile, you must pass a hash as an argument. e,g user[name] .' ,status: :unprocessable_entity)
    else
      params.require(:user).permit(:name, :email,:phone_number,:password,:password_confirmation)
    end
  end

end