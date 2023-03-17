$(document).on 'click', '.submit-msg', (e) ->
  e.preventDefault()

  $this = $(this)
  $form = $this.closest('form')

  if is_not_blank($form.find('.required')) && is_email_valid($form.find('.emailadd'))
    $this.addClass('disabled').html('<i class="fa fa-spin fa-circle-o-notch"></i> Sending').blur()
    $form.submit()
  return
