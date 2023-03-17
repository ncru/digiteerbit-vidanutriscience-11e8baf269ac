$(document).on 'ready page:load', ->
  $('[data-toggle="tooltip"]').tooltip()

  if $('.date').length > 0
    $('.date').datetimepicker({
      timepicker: false,
      format: 'M d, Y'
      });

  if $('input.numeric').length > 0
    $('input.numeric').autoNumeric 'init',
      aSep: ''
      mDec: '2'
      lZero: 'deny'
      vMin: '1'

  if $('input.numeric-no-decimal').length > 0
    $('input.numeric-no-decimal').autoNumeric 'init',
      aSep: ''
      mDec: ''
      lZero: 'deny'
      vMin: '1'

  if $('input.numeric-zero-allowed').length > 0
    $('input.numeric-zero-allowed').autoNumeric 'init',
      aSep: ''
      mDec: '2'
      lZero: 'allow'
      vMin: '0'

  if $('input.numeric-zero-allowed-no-decimal').length > 0
    $('input.numeric-zero-allowed-no-decimal').autoNumeric 'init',
      aSep: ''
      mDec: ''
      lZero: 'allow'
      vMin: '0'

  activator()

  # Automatically remove notices after 5 seconds.
  setTimeout (->
    $('.notice-container').fadeOut 1000, ->
      $('.notice-container').empty()
      $('.notice-container').css 'display', 'block'
      return
    return
  ), 5000

activator = ->
  id = $('#active-id').attr('data-id')
  $('#'+id).addClass('active')
