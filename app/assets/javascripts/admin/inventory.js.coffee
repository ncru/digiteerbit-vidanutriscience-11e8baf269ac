$ ->  
    $(document).on "click", '.add-inventory-btn', (event) ->
      event.preventDefault()
  
      $('input.numeric-zero-allowed-no-decimal').autoNumeric 'init',
        aSep: ''
        mDec: ''
        lZero: 'allow'
        vMin: '0'
      #calling the function for disabling selected products
      disablingFunction()
  
  $(document).on 'change', 'select.sku-id', (event) ->
    sku_id = $(this).val()
    data_id = $(this).parents('tr.nested-fields').attr('id')
    
    stocks = $("input#sku_"+sku_id).data('stocks')
    $(this).parents('tr').find('input.total-stocks').val(stocks)
    # Enabling and disabling of selected option(s)
    jqThis = $(this)
    previous = jqThis.data('prev') # old value of product
    jqThis.data 'prev', jqThis.val()
    value = $('option:selected', this).val()
    $('.sku-id').each ->
      #Enabling the old selected option
      $('.sku-id option[value=\'' + previous + '\']').removeAttr 'disabled'
      #Disabling the recent selected option
      $('.sku-id option[value=\'' + value + '\']').attr 'disabled', 'disabled'
      # -- Select product -- option should not be disabled
      $('.sku-id option[value=\'\']').removeAttr 'disabled'
      return

    $('option[value=\'' + value + '\']', this).removeAttr 'disabled'
    $('.chosen-select').trigger 'chosen:updated'
  
  disablingFunction = ->
    $('.sku-id').each ->
      value = $('option:selected',this).val()
      $('.sku-id option[value=\'' + value + '\']').attr 'disabled', 'disabled'
      $('.sku-id option[value=\'\']').removeAttr 'disabled'
      $('option[value=\'' + value + '\']', this).removeAttr 'disabled'
    $('.chosen-select').trigger 'chosen:updated'
