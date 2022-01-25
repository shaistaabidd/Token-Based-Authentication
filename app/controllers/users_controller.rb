class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def update
    if current_user.update(name: params[:name], email: params[:email], password: params[:password], phone_number: params[:phone_number], company_name: params[:company_name])
      render json: { success: "Profile Updated Successfully!" }
    else
      render json: { error: "Something went wrong. Please try again." }, status: :unauthorized
    end
  end
end
