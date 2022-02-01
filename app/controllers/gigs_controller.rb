class GigsController < ApplicationController
    before_action :params_errors, only: %i(update_gig destroy_gig)
    load_and_authorize_resource except: :create_gig
    def create_gig
        @gig= Gig.new(gig_params)
        @gig.user_id = current_user.id
        if @gig.save
            render json: {message: 'Gig created successfully!',
            gig: @gig}, status: :ok
        else
            render json: {error: @gig.errors.full_messages.join('\n')}, status: :unprocessable_entity
        end
    end

    def update_gig
        if not params_errors
            @gig = Gig.find(params[:id])
            if @gig.update(gig_params)
                render json: {message: 'Gig updated successfully!',
                gig: @gig}, status: :ok
            else
                render json: {error: @gig.errors.full_messages.join('\n')}, status: :unprocessable_entity
            end
        end
        render json: { error: 'Not Authorized' }, status: 401 unless @current_user

    end

    def destroy_gig
        if not params_errors
            @gig = Gig.find(params[:id])
            authorize! :destroy, @gig
            if @gig.destroy
                render json: {message: 'Gig Deleted successfully!',
                }, status: :ok
            else
                render json: {error: @gig.errors.full_messages.join('\n')}, status: :unprocessable_entity
            end
        end
    end

    private

    def gig_params
        params.permit(:user_id, :name,:description,:amount,:review_count,:average_star)
    end

    def params_errors
        if params[:id].blank?
            render json: {error: 'Please enter gig id to update gig!'}, status: :unprocessable_entity
        else
            unless Gig.pluck(:id).include? params[:id].to_i
                render json: {error: 'Gig with this id does not exit!'}, status: :unprocessable_entity
            end
        end


    end
end
