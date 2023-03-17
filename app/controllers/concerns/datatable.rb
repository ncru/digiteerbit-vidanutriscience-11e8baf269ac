module Datatable
  extend ActiveSupport::Concern

  # This method is responsible for building the list of models that will
  # be displayed in the  jQuery DataTables.
  #
  # Parameters:
  # query = The SQL query for obtaining the model.
  # Returns:
  # JSON object needed by jQuery DataTables.
  def build_datatable(query)
    model = query

    model = get_conditions(model) if params[:columns].present?
    model = get_order_clause(model) if params[:order].present?
    model = get_page_data(model)

    # return JSON
    render :json => {
      :data=>model,
      :draw=>params[:draw].to_i,
      :recordsTotal=>query.count(1),
      :recordsFiltered=>model.count(1)
    }
  end

  private
    # This method is responsible for building the conditions being
    # used by the jQuery DataTables to retrieve the data to be
    # displayed.
    #
    # Parameters:
    # @model = The model object being queried.
    # Returns:
    # The model with the added conditions.
    def get_conditions(model)
      # Parse the columns passed by datatables to build SQL where clause.
      params[:columns].each do |key, column_data|
        if column_data[:name].present? && column_data[:search][:value].present?
          # Use like %% if string is passed, = otherwise.
          # if is_numeric?(column_data[:search][:value])
          #   model = model.where("#{column_data[:name]}=?", column_data[:search][:value])
          # else
            model = model.where("#{column_data[:name]}::character varying ilike ?", "%#{column_data[:search][:value]}%")
          # end
        end
      end

      return model
    end

    # This method is responsible for building the order clause
    # being used by the jQuery DataTables.
    #
    # Parameters:
    # @model = The model object being queried.
    # Returns:
    # The model with the added conditions.
    def get_order_clause(model)
      params[:order].each do |key, order_data|
        if order_data[:column].present? && order_data[:dir].present?
          column_to_order = order_data[:column].to_i + 2

          model = model.order("#{column_to_order} #{order_data[:dir]}")
        end
      end

      return model
    end

    # This method is responsible for obtaining the data on a specific
    # page when there are multiple pages.
    #
    # Parameters:
    # @model = The model object being queried.
    # Returns:
    # The paginated model.
    def get_page_data(model)
      return model.paginate(:page=>page, :per_page=>per_page)
    end

    # Get the page number.
    def page
      (params[:start].to_i/per_page)+1
    end

    # Number of items per page as passed by DataTables.
    def per_page
      params[:length].to_i
    end

    # This is a helper method that checks whether and object is numeric or not.
    #
    # Parameters:
    # @obj = The object to check if numeric or not.
    # Returns:
    # True if the object is numeric, False otherwise.
    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
end
