# Change event listener for the SKU select element on Product details page.
$('#sku').on 'change', (e) ->
  e.preventDefault()
  $this = $(this)
  $selected_option = $this.find(':selected')
  $price = $selected_option.data('price')
  $promo_price =  $selected_option.data('promoprice')

  # Update the price.
  $this.parents('.wrapper-product-details').find('.original-price').text($price)
  if $promo_price != '' && parseFloat($promo_price) > 0
    $this.parents('.wrapper-product-details').find('.original-price').addClass('line-through')
    $this.parents('.wrapper-product-details').find('.promo-price').text(' / ₱'+$promo_price)
  else
    $this.parents('.wrapper-product-details').find('.original-price').removeClass('line-through')
    $this.parents('.wrapper-product-details').find('.promo-price').text('')
  input = $("#sku-quantity")
  
  # Update the form data.
  sku_id = $selected_option.val()
  available_stocks = parseInt($('#sku_'+sku_id).data('available-stocks'))
  items_in_cart = parseInt($('#sku_'+sku_id).data('qty-in-current-cart'))
  allowable_purchase = available_stocks - items_in_cart
  $('.shop-form').find('[name="cart_item[sku_id]"]').val(sku_id)
  
  input.attr('max', allowable_purchase)
  
  # Set the initial value to 1.
  $('#sku-quantity').val(1)

  # Set the form data.
  $('.shop-form').find('[name="cart_item[quantity]"]').val(1)
  return

$(document).on 'click', '.spinner.product-details .btn:first-of-type', (e) ->
  e.preventDefault()
  
  btn = $(this)
  input = btn.parent().find('input')
  value = input.val()
  max = parseInt(input.attr('max'))
  min = parseInt(input.attr('min'))
  current_quantity = if value == '' or value == undefined then min else value
  sku_id = $('#sku option:selected').val()
  available_stocks = parseInt($('#sku_'+sku_id).data('available-stocks'), 10)
  items_in_cart = parseInt($('#sku_'+sku_id).data('qty-in-current-cart'), 10)
  allowable_purchase = parseInt(available_stocks - items_in_cart)
  
  current_quantity = if current_quantity < allowable_purchase then parseInt(current_quantity, 10) + 1 else max
  
  # Set the value.
  input.val(current_quantity)
    
  # Set the form data.
  $('.shop-form').find('[name="cart_item[quantity]"]').val(current_quantity)
  return

$(document).on 'click', '.spinner.product-details .btn:last-of-type', (e) ->
  e.preventDefault()
  
  btn = $(this)
  input = btn.parent().find('input')
  max = parseInt(input.attr('max'))
  min = parseInt(input.attr('min'))
  
  current_quantity = if input.val() == '' or input.val() == undefined then min else input.val()
  
  # Handle if customer type quantity that is greater than the max attribute.
  if current_quantity > max then current_quantity = max + 1
  if current_quantity > 1 then current_quantity = current_quantity - 1
  
  # Set the value.
  input.val(current_quantity)
    
  # Set the form data.
  $('.shop-form').find('[name="cart_item[quantity]"]').val(current_quantity)
  return

$(document).on 'click', '.toggle-delete-modal', (e) ->
  e.preventDefault()
  
  $this = $(this)
  type = $this.data("type")
  id = $this.data("id")
  
  $('#'+type+'_delete_modal').modal('toggle')
  $('#delete-cart-item-form').find("input[name='id']").val(id)
  return

$(document).on 'click', '.add-to-bag', (e) ->
  e.preventDefault()
  
  $this = $(this)
  form = $this.closest('form')
  modal = $('#confirmation_modal')
  sku_id = $this.siblings('input[name="cart_item[sku_id]"]').val()
  available_stocks = parseInt($('#sku_'+sku_id).data('available-stocks'), 10)
  items_in_cart = parseInt($('#sku_'+sku_id).data('qty-in-current-cart'), 10)
  allowable_purchase = parseInt(available_stocks - items_in_cart)
  input_qty = $("#sku-quantity")
  qty = input_qty.val()
  
  if qty > allowable_purchase
    modal.find('.modal-body .attempted-qty').html(qty)
    modal.find('.modal-body .available-qty').html(allowable_purchase)
    modal.find('.modal-footer #proceed-add').attr('data-qty', allowable_purchase)
    modal.find('.modal-footer #proceed-add').html('Proceed with ' + allowable_purchase)
    if allowable_purchase == 0 then modal.find('.modal-footer').addClass 'hidden' else modal.find('.modal-footer').removeClass 'hidden' 
    modal.modal('show')
  else
    # Set the form data.
    $('.shop-form').find('[name="cart_item[quantity]"]').val(qty)
    form.submit()
  return

$(document).on 'click', '#proceed-add', (e) ->
  e.preventDefault()
  
  $this = $(this)
  form = $('.shop-form')
  modal = $('#confirmation_modal')
  qty = $this.data('qty')
  
  # Set the form data.
  form.find('[name="cart_item[quantity]"]').val(qty)
  # Hide the modal.
  modal.modal('hide')
  # Submit the form.
  form.submit()
  
  
  
