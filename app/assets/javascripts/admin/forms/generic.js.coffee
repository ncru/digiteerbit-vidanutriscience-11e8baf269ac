$(document).on 'click', '.submit-summernote', (e) ->
  e.preventDefault()
  $this = $(this)

  if is_not_blank('.required') && is_email_valid('.email')
    $('.note-editable').each ->
      $this.parents().eq(1).find('textarea').val($(this).html())
    $this.addClass('disabled')
    $this.html('Saving...').blur()
    $('form').eq(0).submit()

$(document).on 'click', '.submit-summernote-with-association', (e) ->
  e.preventDefault()
  $this = $(this)
  parent_tab_content_id = $('.skus .nested-fields').parents('.tab-content').attr('id')
  li_parent = $('a[target="'+parent_tab_content_id+'"]').parent()

  # Validate if there's at least one sku Mapping for the Product.
  if $('.skus .nested-fields').length < 1 && li_parent.hasClass('active')
    $('#error-msg-div').text('Please enter at least one SKU.')
    $('#error-msg-div').removeClass('hidden')
    return
  else
    $('#error-msg-div').addClass('hidden')

  # Validate all required fields.
  if is_not_blank('.required') && is_email_valid('.email')
    $('.note-editable').each ->
      $this.parents().eq(1).find('textarea').val($(this).html())
    $this.addClass('disabled')
    $this.html('Saving...').blur()
    $('form').eq(0).submit()

$(document).on "click", '.submit-price-update', (event) ->
  event.preventDefault()
  $this = $(this)
  # Validate all required fields.
  if is_not_blank('.required') && is_higher('.is-higher')
    if $('.price-update-items .nested-fields').length < 1
      $("#error-msg-div").text('*Please enter atleast one Product.')
      $("#error-msg-div").removeClass('hidden')
      setTimeout (->
        $('#error-msg-div').addClass 'hidden'
        return
      ), 2000
      return
    else
      $("#error-msg-div").addClass('hidden')
      $this.addClass('disabled')
      $this.html('Saving...').blur()
      $('form#new_price_update').eq(0).submit()
      return

$(document).on "click", '.submit-inventory', (event) ->
  event.preventDefault()
  $this = $(this)
  # Validate all required fields.
  if is_not_blank('.required') && is_higher2('.is-higher')
    if $('.inventory-items .nested-fields').length < 1
      $("#error-msg-div").text('*Please enter atleast one Product.')
      $("#error-msg-div").removeClass('hidden')
      setTimeout (->
        $('#error-msg-div').addClass 'hidden'
        return
      ), 2000
      return
    else
      $("#error-msg-div").addClass('hidden')
      $this.addClass('disabled')
      $this.html('Saving...').blur()
      $('form').eq(0).submit()
      return

# Handler for the confirmation delete button in the delete modal.
$(document).on "click", '[class*="confirm delete-"]', (event) ->
  event.preventDefault()
  $this = $(this)
  $this.addClass("disabled")
  $this.html('Deleting...').blur()
