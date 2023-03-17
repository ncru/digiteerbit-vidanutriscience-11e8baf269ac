module Site
  class ProductReviewsController < SiteController

    def create
      @product_review = ProductReview.new(product_review_params)
      
      if @product_review.save
        @product = @product_review.product
      else
        render :action => "error"
      end
    end

    private
      def product_review_params
        params.require(:product_review).permit(:customer_id, :product_id, :rating, :review)
      end
  end
end
