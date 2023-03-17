module Admin
  class ProductReviewsController < AdminController
    # GET /admin/reviews
    def index
      @reviews = ProductReview.for_datatables
    end

    # GET /admin/reviews/:id
    def show
      @product = Product.find(params[:id])
      @product_reviews = ProductReview.for_review_datatables(params[:id])
    end

    # def update
    #   @product_review = ProductReview.find(params[:id])
    #   unless @product_review.update(product_review_params)
    #     render action: "error"
    #   end
    # end

    def destroy
      @product_review = ProductReview.find(params[:id])
      @product_review.destroy
      respond_to do |format|
        flash[:notice] = "Product Review of <strong>" + @product_review.customer.first_name + "</strong> has been successfully removed."
        log_to_audittrail('delete', 'PRODUCT REVIEW', @product_review.customer.first_name + " " + @product_review.customer.first_name)

        flash.discard if ProductReview.for_review_datatables(@product_review.product_id).count(1) == 0

        format.html { redirect_to "/admin/product-reviews/#{@product_review.product_id}"}
      end
    end

    # POST /admin/datatables/retrieve_reviews
    def populate_datatables
      @reviews = build_datatable(ProductReview.for_datatables)

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @reviews }
      end
    end

    # POST /admin/datatables/retrieve_product_reviews
    def populate_review_datatables
      @product_reviews = build_datatable(ProductReview.for_review_datatables(params[:product_id]))

      # Return the data being expected by the client.
      respond_to do |format|
        format.json  { @product_reviews }
      end
    end

    private
      def product_review_params
        params.require(:product_review).permit(:status)
      end

  end
end
