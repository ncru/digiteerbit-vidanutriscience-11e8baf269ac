$ ->
  $(document).on "change", "#division_id", (e) ->
    e.preventDefault()
    $this = $(this)
    division_id = if $this.val() == '' then 0 else $this.val()
    
    $.ajax
      url: '/admin/json/retrieve_sub_categories'
      type: 'POST'
      data: 'product[division_id]': division_id
      dataType: 'json'
      success: (data) ->
        # Clean the options first.
        $('#sub_division_ids option:gt(0)').remove()
        
        # Build the new options.
        options = ''
        $.each data.sub_categories, (i, sub_category) ->
          options += '<option value="' + sub_category.id + '">' + sub_category.name + '</option>'
          return

        # Append the new options.
        $('#sub_division_ids').append(options);
        # Determine disabled property.
        $('#sub_division_ids').attr('disabled', data.sub_categories.length < 1)
        # Update the chosen instance.
        $('#sub_division_ids').trigger('chosen:updated');
        
      error: (jqXHR, textStatus, errorThrown) ->
        alert('Error encountered: ' + errorThrown)
    return
  
  # $(document).on "keyup", ".item-stock-field", (e) ->
  #   e.preventDefault()
  #   calculate_total_stocks()

  $("#skus").on("cocoon:before-insert", (e, sku_to_add) ->
    sku_to_add.fadeIn(400)
  ).on("cocoon:after-insert", (e, added_sku) ->

    # Instantiate the numeric inputs.
    added_sku.find("input.numeric-no-decimal").autoNumeric "init",
      aSep: ""
      mDec: ""
      lZero: "deny"
      vMin: "1"

    # Instantiate the numeric inputs.
    added_sku.find("input.numeric").autoNumeric "init",
      aSep: ""
      mDec: "2"
      lZero: "deny"
      vMin: "1"
      
    # Instantiate the Switch Elements.
    elems = Array::slice.call(added_sku[0].querySelectorAll('.js-switch'))
    elems.forEach (elem) ->
      if elem.dataset.enabled
        switchery = new Switchery(elem, {secondaryColor: '#f0f1f1', disabled: true})
      else
        switchery = new Switchery(elem, {secondaryColor: '#f0f1f1'})
      return
    
    # Instantiate the tags input.
    added_sku.find("input[data-role=tagsinput]").tagsinput()
    
    # Instantiate tooltips.
    added_sku.find('[data-toggle="tooltip"]').tooltip()

    # Update the photo table id for proper referencing.
    # identifier will get the id of the first input element which is the code.
    identifier = added_sku.find(".form-control").first().attr("id")
    from = identifier.indexOf("_attributes_")+12
    to = identifier.indexOf("_code")

    # Assign the id by retrieving only the integer value in the id.
    new_id = "photo-table-" + identifier.substring(from, to)
    added_sku.find("#photo-table-").attr("id", new_id)

    # Scroll to the location of the added sku field.
    $("html, body").animate { scrollTop: $(added_sku).offset().top - 81 }, 500
    return
  )

  # calculate_total_stocks = ->
  #   total_stocks = 0
  #   $(".nested-fields:visible").find(".item-stock-field").each ->
  #     total_stocks = total_stocks + parseInt($(this).val())
  #   $("#product_total_stocks").val(total_stocks)
    
  $("#faqs").on("cocoon:before-insert", (e, faq_to_add) ->
    faq_to_add.fadeIn(400)
  ).on("cocoon:after-insert", (e, added_faq) ->
      
    # Instantiate the Switch Elements.
    elems = Array::slice.call(added_faq[0].querySelectorAll('.js-switch'))
    elems.forEach (elem) ->
      if elem.dataset.enabled
        switchery = new Switchery(elem, {secondaryColor: '#f0f1f1', disabled: true})
      else
        switchery = new Switchery(elem, {secondaryColor: '#f0f1f1'})
      return
    
    # Instantiate tooltips.
    added_faq.find('[data-toggle="tooltip"]').tooltip()

    # Scroll to the location of the added faq field.
    $("html, body").animate { scrollTop: $(added_faq).offset().top - 81 }, 500
    return
  ).on("cocoon:before-remove", (e, faq_to_remove) ->
    faq_to_remove.fadeOut(400)
    return
  )
