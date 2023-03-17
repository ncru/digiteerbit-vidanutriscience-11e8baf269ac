$(document).ready ->
  elems = Array::slice.call(document.querySelectorAll('.js-switch'))
  elems.forEach (elem) ->
    if elem.dataset.enabled
      switchery = new Switchery(elem, {secondaryColor: '#f0f1f1', disabled: true})
    else
      switchery = new Switchery(elem, {secondaryColor: '#f0f1f1'})
    return
  return

$ ->
  # Ignore click on slider anchor image when clicking the
  # switchery element.
  $(document).on 'click', '.switchery', (e) ->
    return false