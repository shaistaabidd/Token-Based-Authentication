class CreateGig
    include Interactor
    
    def call
        gig_params
        @gig= Gig.new(gig_params)
        @gig.user_id = current_user.id
        if @gig.save
            context.message = "Gig is saved Successfully!" 
        else
            context.fail!(message: @gig.errors, status: :unprocessable_entity)
        end
        context.gig = @gig
    end

    def current_user
        context.current_user
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
