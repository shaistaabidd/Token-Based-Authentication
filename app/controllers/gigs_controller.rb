class GigsController < ApplicationController
    before_action :params_errors, only: %i(update destroy)
    load_and_authorize_resource except: :create_gig
    def create
        @result = CreateGig.call(params: params, current_user: current_user)
        if @result.success?
            render json: {
                gig: {
                user_id: @result.gig.user_id,
                name: @result.gig.name,
                description: @result.gig.description,
                amount: @result.gig.amount,
                review_count: @result.gig.review_count,
                average_star: @result.gig.average_star,
                created_at: @result.gig.created_at.strftime("%d-%m-%Y, %z %H:%M:%S"),
                status: @result.message
                }
            },status: :ok
        else
            render json: {error: (@result.message)}, status: @result.status
        end
    end

    def update
        @result = UpdateGig.call(params: params)
        if @result.success?
            render json: {
                gig: {
                user_id: @result.gig.user_id,
                name: @result.gig.name,
                description: @result.gig.description,
                amount: @result.gig.amount,
                review_count: @result.gig.review_count,
                average_star: @result.gig.average_star,
                updated_at: @result.gig.created_at.strftime("%d-%m-%Y, %z %H:%M:%S"),
                status: @result.message
                }
            },status: :ok
        else
            render json: {error: (@result.message)}, status: @result.status
        end
    end

    def destroy
        @result = DestroyGig.call(params: params)
        if @result.success?
            render json: { status: @result.message }, status: :ok
        else
            render json: {error: (@result.message)}, status: @result.status
        end
    end

    private

    def gig_params
        params.permit(:user_id, :name,:description,:amount,:review_count,:average_star)
    end

    def params_errors
        unless Gig.find_by_id(params[:id]).present?
            render json: {error: 'Gig with this id does not exit!'}, status: :not_found
        end
    end
end
