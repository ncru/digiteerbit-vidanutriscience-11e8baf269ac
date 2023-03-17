$(document).on 'click', '.submit-orders', (e) ->
  e.preventDefault()

  $this = $(this)
  $form = $this.closest('form')

  if is_not_blank($form.find('.required')) && is_email_valid($form.find('.emailadd'))
    $('.submit-orders').addClass('disabled')
    $this.html('<i class="fa fa-spin fa-circle-o-notch"></i> Please wait...').blur()
    $form.submit()
  return

$(document).on 'click', '.submit-payment-method', (e) ->
  e.preventDefault()
  
  $this = $(this)
  $form = $this.closest('form')
  $checked_payment_method = $("[name='order[payment_method_id]']:checked")
  
  if parseInt($checked_payment_method.val()) == 3
    $form.data('remote', true)
  else
    $form.data('remote', false)
        
  if $checked_payment_method.length > 0
    $this.addClass('disabled')
    $('#select-payment-method').removeClass('text-danger')
      
    $this.html('<i class="fa fa-spin fa-circle-o-notch"></i> Please wait...').blur()
    $form.submit()
  else
    $('#select-payment-method').addClass('text-danger').html("Please select a payment method.")
  return
  
  
  
$(document).on 'change', 'select#courier-id', (e) ->
  e.preventDefault()
  courier_id = $(this).val()
  shipping_rate_id = $('select#shipping-country-code').find('option:selected').data('srid')
  shipping_country_code = $('select#shipping-country-code').val()
  postal_code = $("#order_shipping_zip_code").val()
  $form = $(this).closest('form')
  if is_not_blank($form.find('.required'))
    $('.checkout-loader').fadeIn()
    $.ajax
      url: '/site/json/shipping-fee'
      type: 'POST'
      data: 'courier_id': courier_id, 'shipping_rate_id': shipping_rate_id, "shipping_country_code": shipping_country_code, 'postal_code': postal_code
      dataType: 'script'
      success: (data) ->
        return
      error: (jqXHR, textStatus, errorThrown) ->
        return
  else
    $(this).val('')

$(document).on 'change', 'select#shipping-country-code', (e) ->
  e.preventDefault()
  
  $("select#courier-id").val("")
  # shipping_rate_id = $(this).find('option:selected').data('srid')
  shipping_country_code= $(this).val()
  
  if shipping_country_code == 'PH'
    $('#courier-select').addClass('hidden').find('select').removeClass('required');
    $('select[name="order[shipping_state_id]"]').removeClass('hidden').addClass('required').val('')
    $('input[name="order[shipping_state]"]').addClass('hidden')
    $('select[name="order[shipping_city_id]"]').removeClass('hidden').val('').addClass('required')
    $('input[name="order[shipping_city]"] ').addClass('hidden')
    $('.fa-caret-down.ph').removeClass('hidden')
  else
    $('#courier-select').removeClass('hidden').find('select').addClass('required');
    $('input[name="order[shipping_state]"]').removeClass('hidden')
    $('select[name="order[shipping_state_id]"]').addClass('hidden').val('').removeClass('required')
    $('input[name="order[shipping_city]"]').removeClass('hidden')
    $('select[name="order[shipping_city_id]"]').addClass('hidden').val('').removeClass('required')
    $('.fa-caret-down.ph').addClass('hidden')
    
  default_scc = $(this).data 'default'
  if default_scc == shipping_country_code
    $('.shipping-address-wrapper input').each ->
      $this = $(this) 
      $this.val($this.data("default"))
  else
    $('.shipping-address-wrapper').find('input').val('');
  return

$(document).on 'keyup', '#order_shipping_zip_code', (e) ->
  e.preventDefault()
  $("select#courier-id").val("")
  return


$(document).on 'change', '#shipping_state', (e) ->
  e.preventDefault()
  $this = $(this)
  province_id   = if $this.val() == '' then 0 else $this.val()
  province_name = $('option:selected', $this).text()
  # region_id     = $('option:selected', $this).data('regionid')
  
  # Set province name in the hidden field.
  $this.siblings('input[name="order[shipping_state]"]').val(province_name)
  # $this.siblings('input[name="order[shipping_region_id]"]').val(region_id)
  
  $.ajax
    url: '/site/json/retrieve_cities'
    type: 'POST'
    data: 'province_id': province_id
    dataType: 'json'
    success: (data) ->
      # Clean the options first.
      $('#shipping_city').empty()
      
      # Build the new options.
      options = '<option value>Select City</option>'
      $.each data.cities, (i, city) ->
        options += '<option value="' + city.id + '">' + city.name + '</option>'
        return

      # Append the new options.
      $('#shipping_city').append(options);
      # Determine disabled property.
      $('#shipping_city').attr('disabled', data.cities.length < 1)
      
    error: (jqXHR, textStatus, errorThrown) ->
      alert('Error encountered: ' + errorThrown)
  return
  
$(document).on 'change', '#shipping_city', (e) ->
  e.preventDefault()
  $this = $(this)
  city_name = $('option:selected', $this).text()
  # Set city name in the hidden field.
  $this.siblings('input[name="order[shipping_city]"]').val(city_name)
  
  return
  
