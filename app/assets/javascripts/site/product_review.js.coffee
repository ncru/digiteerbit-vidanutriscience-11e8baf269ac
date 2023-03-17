$(document).on 'click', '.submit-review', (e) ->
  e.preventDefault()

  $this = $(this)
  $form = $this.parents('form')

  if is_not_blank($form.find('.required'))
    $this.addClass('disabled').html('<i class="fa fa-spin fa-circle-o-notch"></i> Sending').blur()
    $form.submit()
  return

# Catch the closing event of the Review modal to clear all form details.
$('#modalReview').on 'hidden.bs.modal', (e) ->
  $form = $('#new_product_review')

  $form[0].reset()
  $('#product_review_rating').rating('update', 1)
  $form.find('.error-msg').empty().addClass('hidden')
  $('.container-error').empty()
  return
