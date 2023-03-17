$ ->
  $(document).on 'click', '.save-details', (e) ->
    e.preventDefault();
    
    $this = $(this)
    $form = $this.parents('form')

    if is_not_blank($form.find('.required'))
      $this.addClass('disabled').html('<i class="fa fa-spin fa-circle-o-notch"></i> Saving').blur()
      $form.submit()
    return
