$ ->
   # if the price update is for promo discount
  $(document).on "change", 'select#price-type', (event) ->
    event.preventDefault()
    value = $(this).val() 
    if $(this).val() == '1'
      $('.promo-fields-wrapper').slideDown()
      $('.promo-hidden').removeClass 'hidden'
      $('input.promo-price').addClass 'required is-higher'
      $('select.promo-type').addClass 'required'
      $('input.regular-price').attr 'readonly', 'true'
    else
      $('.promo-fields-wrapper').slideUp()
      $('.promo-hidden').addClass 'hidden'
      $('input.promo-price').removeClass 'required is-higher'
      $('select.promo-type').removeClass 'required'
      $('select.promo-type').val('').trigger('chosen:updated')
      $('input.regular-price').removeAttr 'readonly'
    
    # for disabling sale price input
    promo_type = $('select.promo-type').val()
    if promo_type == ''
      $('input.promo-price').attr 'disabled', 'disabled'
    else
      $('input.promo-price').removeAttr 'disabled'

  $(document).on "click", '.add-product-btn', (event) ->
    event.preventDefault()
    if $('select#price-type').val() == '1'
      $('.promo-hidden').removeClass 'hidden'
      $('input.promo-price').addClass 'required is-higher'
      $('input.regular-price').attr 'readonly', 'true'
    else
      $('input.promo-price').removeClass 'required is-higher'
      $('.promo-hidden').addClass 'hidden'
      $('input.regular-price').removeAttr 'readonly'

    $('.numeric').autoNumeric 'init',
      aSep: ''
      mDec: 2
      lZero: 'deny'
      vMin: '0'
      vMax: 9999999
    #calling the set_sale_input function
    set_sale_input()
    #calling the function for disabling selected products
    disablingFunction()

  $(document).on "click", '#remove-product-btn', (event) ->
    event.preventDefault()
    data_id = $(this).parents('.nested-fields').attr('id')
    value = $('#'+data_id+'').find('.sku_id').children('option:selected').val()
    if value != ''
      $('.sku_id').each ->
        $('.sku_id option[value=\'' + value + '\']').removeAttr 'disabled'
      $('.chosen-select').trigger 'chosen:updated'
      $('#'+data_id+'').find('.sku_id').children('option:selected').val(null)


  $(document).on 'change', 'select.promo-type', (event) ->
    event.preventDefault()
    #calling set_sale_input function
    set_sale_input()
    $('input.promo-price').val('')
    $('input.new-price').val('')

  $(document).on "keyup change", 'input.promo-price', (event) ->
    sale_type = $('select.promo-type').val()
    value = $(this).val()
    data_id = $(this).parents('tr.nested-fields').attr('id')   
    if sale_type == '1'
      $('#' + data_id).find('input.new-price').val(value)
      return
    else if sale_type == '2'
      price = parseFloat($('#' + data_id).find('input.regular-price').val())
      percent = parseInt(value)
      total = [(100 - percent)*price] / 100
      if total > 0
        $('#' + data_id).find('input.new-price').val(total)
        return
      else 
        $('#' + data_id).find('input.new-price').val(0)
        return
  $(document).on 'ready page:load', ->
    # Getting the old value of material_id before change
    $('.sku_id').data 'prev', $('.sku_id').val()
    #disablingFunction() #calling a function
    return

  $(document).on 'change', 'select.sku_id', (event) ->
    sku_id = $(this).val()
    data_id = $(this).parents('tr.nested-fields').attr('id')
    # Getting Regular Price
    if $('select#price-type').val() == '1' && sku_id != ''
      $.ajax
        url: '/admin/price-updates/get_sku_price'
        type: 'POST'
        data: 'sku_id': sku_id, 'data_id': data_id
        success: (data) ->
          return
        error: (jqXHR, textStatus, errorThrown) ->
          return
    else
      $("#"+data_id).find('input.regular-price').val('')
    
    # Enabling and disabling of selected option(s)
    jqThis = $(this)
    previous = jqThis.data('prev') # old value of product
    jqThis.data 'prev', jqThis.val()
    value = $('option:selected', this).val()
    $('.sku_id').each ->
      #Enabling the old selected option
      $('.sku_id option[value=\'' + previous + '\']').removeAttr 'disabled'
      #Disabling the recent selected option
      $('.sku_id option[value=\'' + value + '\']').attr 'disabled', 'disabled'
      # -- Select product -- option should not be disabled
      $('.sku_id option[value=\'\']').removeAttr 'disabled'
      return

    $('option[value=\'' + value + '\']', this).removeAttr 'disabled'
    $('.chosen-select').trigger 'chosen:updated'

  
  # function for Disabling all selected product
  disablingFunction = ->
    $('.sku_id').each ->
      value = $('option:selected',this).val()
      $('.sku_id').each ->
        $('.sku_id option[value=\'' + value + '\']').attr 'disabled', 'disabled'
        $('.sku_id option[value=\'\']').removeAttr 'disabled'

      $('option[value=\'' + value + '\']', this).removeAttr 'disabled'
    $('.chosen-select').trigger 'chosen:updated'

  # function for setting the sale price input value
  set_sale_input = ->
    sale_type = $('select.promo-type').val()
    mDecimal=''
    if sale_type == '2'
      $('.th-text').text("Discount (%)")
      mDecimal = ''
      vMaximum = '99'
    else if sale_type == '1'
      $('.th-text').text("Sale Price")
      mDecimal = '2'
      vMaximum = '999999'
    $('input.promo-price').autoNumeric 'destroy'
    $('input.promo-price').autoNumeric 'init',
      aSep: ''
      mDec: mDecimal
      lZero: 'deny'
      vMin: '0'
      vMax: vMaximum
    # for disabling sale price input
    promo_type = $('select.promo-type').val()
    if promo_type == ''
      $('input.promo-price').attr 'disabled', 'disabled'
    else
      $('input.promo-price').removeAttr 'disabled'