$(document).ready ->
  # Call this only on shop and brands page.
  if location.pathname.indexOf('shop') > 0 or location.pathname.indexOf('brands') > 0
    
    slug = ""
    if location.pathname.indexOf('brands') > 0 # Get the slug if on brands page.
      array = location.pathname.split("/")
      slug = array.pop()
      
      # Handle if the url ends in '/'
      if slug == '' then slug = array[array.length-1]
      
    filters = {
      brands: []
      subcategories: []
      order_by: ""
    }

    $('.filter-skus-controls').change ->
      switch $(this).data('type')
        when 'brands'
          filters.brands = []
          brands = $('[data-type="brands"]:checked')

          $.each brands, (i, v) ->
            filters.brands.push($(v).data('brand-id'))
            return
        when 'sub_categories'
          filters.subcategories = []
          subcategories = $('[data-type="sub_categories"]:checked')

          $.each subcategories, (i, v) ->
            filters.subcategories.push($(v).data('subcategory-id'))
            return
        when 'order'
          order_by_item = $('[data-type="order"]:checked')
          filters.order_by = order_by_item.data('order-field') + " " + order_by_item.data('order')

      # Filter via AJAX.
      $.ajax
        url: '/site/json/filter_skus'
        type: 'POST'
        data: 'filters': JSON.stringify(filters), 'slug': slug
        dataType: 'script'
        success: (data) ->
          return
        error: (jqXHR, textStatus, errorThrown) ->
          return
      return

    $(document).on 'click', '.clear-all-filters', (event) ->
      event.preventDefault()
      $("input[type=checkbox]").prop('checked', false)

      filters.brands = []
      
      # Filter via AJAX.
      $.ajax
        url: '/site/json/filter_skus'
        type: 'POST'
        data: 'filters': JSON.stringify(filters), 'slug': slug
        dataType: 'script'
        success: (data) ->
          return
        error: (jqXHR, textStatus, errorThrown) ->
          return
      return
    
