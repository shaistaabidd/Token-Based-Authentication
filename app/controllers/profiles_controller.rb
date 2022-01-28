class ProfilesController < ApplicationController
    def update
        if not params[:password].present?
          if params[:email].present?
            current_user.update(email: params[:email])
          end
    
          if params[:name].present?
            current_user.update(name: params[:name])
          end
    
          if params[:phone_number].present?
            current_user.update(phone_number: params[:phone_number])
          end
    
          if params[:company_name].present?
            current_user.update(company_name: params[:company_name])
          end
          render json: { success: "Profile Updated Successfully!", user: current_user }
        else
          if params[:password].present?
            if check_passwords
              current_user.update(password: params[:password], password_confirmation: params[:password_confirmation])
              render json: { success: "Profile Updated Successfully!", user: current_user }
            else
              render json: { error: "Password confirmation is not matched with your password." }, status: :bad_request
            end
          end
        end
    
    
        # if params[:password].present? 
        #   if check_passwords
        #     current_user.update(name: params[:name], email: params[:email], password: params[:password], phone_number: params[:phone_number], company_name: params[:company_name])
        #     render json: { success: "Profile Updated Successfully!", user: current_user }
        #   else
        #     render json: { error: "Password confirmation is not matched with your password." }, status: :bad_request
        #   end
        # else
        #   current_user.update(name: params[:name], email: params[:email], phone_number: params[:phone_number], company_name: params[:company_name])
        #   render json: { success: "Profile Updated Successfully!", user: current_user }
        # end
        
    end
    
    def check_passwords
        params[:password] == params[:password_confirmation]
    end
    

end
