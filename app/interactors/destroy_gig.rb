class DestroyGig
    include Interactor

    def call
        @gig = Gig.find(params[:id])
        if @gig.destroy
            context.message = "Gig is deleted Successfully!" 
        else
            context.fail!(message: @gig.errors, status: :unprocessable_entity)
        end
    end

    def params
        context.params
    end


end