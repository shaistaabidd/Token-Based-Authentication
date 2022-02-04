class ProfilesController < ApplicationController

  def update
    @result = ProfileUpdate.call(params: params, current_user: current_user)
    if @result.success?
      render json: {
        user: {
          name: @result.user.name,
          email: @result.user.email,
          phone_number: @result.user.phone_number,
          created_at: @result.user.created_at.strftime("%d-%m-%Y, %z %H:%M:%S"),
          status: @result.message
        }
      },status: :ok
    else
      render json: {error: (@result.message)}, status: @result.status
    end
  end

end
