class UpdateGig
    include Interactor

    def call
        gig_params
        @gig = Gig.find(params[:id])
        if @gig.update(gig_params)
            context.message = "Gig is updated Successfully!" 
        else
            context.fail!(message: @gig.errors, status: :unprocessable_entity)
        end
        context.gig = @gig
    end

    def params
        context.params
    end

    def gig_params
        if not params[:gig].present?
            context.fail!(message:'When assigning attributes, you must pass a hash as an argument. e,g gig[name] .' ,status: :unprocessable_entity)
        else
            params.require(:gig).permit(:user_id, :name,:description,:amount,:review_count,:average_star)
        end
    end

end