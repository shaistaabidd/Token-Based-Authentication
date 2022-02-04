class ProfileUpdate
  include Interactor

  def call
    user_params
    if params[:user].present? and not current_user.update(user_params)
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
    if not params[:user].present? and params.keys.count > 2
      context.fail!(message:'When assigning attributes, you must pass a hash as an argument. e,g user[name] .' ,status: :unprocessable_entity)
    else
      params.require(:user).permit(:name, :email,:phone_number,:password,:password_confirmation) if params[:user].present?
    end
  end

end