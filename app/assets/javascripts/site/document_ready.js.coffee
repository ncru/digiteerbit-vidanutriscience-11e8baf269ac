$ ->

  $('.contact-number').regexMask /^[\d\s()\-+,]*$/
  # Filter for email address field.
  $('.emailadd').regexMask /^[\w\d\s._@\-]*$/
  
  $('.postal').regexMask /^[\w\d\s_\-]*$/
  
$(document).ready ->
  checkNav()
  $('.panel-collapse').on 'show.bs.collapse', ->
    $(this).siblings('.panel-heading').parent().addClass 'active'
  $('.panel-collapse').on 'hide.bs.collapse', ->
    $(this).siblings('.panel-heading').parent().removeClass 'active'
  return
  
$(document).on 'ready page:load', ->
  # Remove all hashes in the URL.
  if window.location.hash.search('#_') >= 0
    history.pushState '', document.title, window.location.pathname
  return

# Toggle visible mobile menu
$('.mobile-menu-toggle').click (e) ->
  e.preventDefault()
  $('body').removeClass 'menu-toggled'
  return

# Function to add class on navbar after scrolling 140px
checkNav = ->
  if $(window).scrollTop() > 140
    $('.navbar-vida').addClass 'navbar-scroll'
    $('.yield-container').addClass 'toggle'
  else
    $('.navbar-vida').removeClass 'navbar-scroll'
    $('.yield-container').removeClass 'toggle'
  return

$(window).scroll ->
  checkNav()
  return

# Center modal
setModalMaxHeight = (element) ->
  @$element = $(element)
  @$content = @$element.find('.modal-content')
  borderWidth = @$content.outerHeight() - @$content.innerHeight()
  dialogMargin = if $(window).width() < 768 then 20 else 60
  contentHeight = $(window).height() - (dialogMargin + borderWidth)
  headerHeight = @$element.find('.modal-header').outerHeight() or 0
  footerHeight = @$element.find('.modal-footer').outerHeight() or 0
  maxHeight = contentHeight - (headerHeight + footerHeight)
  @$content.css 'overflow': 'hidden'
  @$element.find('.modal-body').css
    'max-height': maxHeight
    'overflow-y': 'auto'
  return

$('.modal-center').on 'show.bs.modal', ->
  $(this).show()
  setModalMaxHeight this
  return
  
$(window).resize ->
  if $('.modal-center.in').length != 0
    setModalMaxHeight $('.modal-center.in')
  return
  
$('#topbarCart').click (e) ->
  e.preventDefault()
  $('body').addClass 'cart-toggled'
  return
  
$('.close-cart').click (e) ->
  e.preventDefault()
  $('body').removeClass 'cart-toggled'
  return
  
$('.close-menu').click (e) ->
  e.preventDefault()
  $('body').removeClass 'menu-toggled'
  return
  
$('.topbar-overlay').click (e) ->
  e.preventDefault()
  $('body').removeClass 'cart-toggled menu-toggled'
  return
  
$('.toggle-overlay').click (e) ->
  e.preventDefault()
  $('body').removeClass 'cart-toggled menu-toggled'
  return
  
$('#test').change ->
  $('#billing').toggle()
    
