$(document).ready ->
  h = $('body').height()+50

  $('.sidebar-fixed').slimScroll
    railVisible: false
    railOpacity: 0
    height: h+'px'

  highlightActiveMenuItem()

# Handles the higlighting of the selected menu menu
# on the Admin Sidebar.
highlightActiveMenuItem = ->
  currentPageUrl = location.pathname
  menuItems = $('.sidebar-fixed ul li a')

  $.each menuItems, (i, v) ->
    if currentPageUrl.indexOf($(this).attr('href')) != -1
      $(this).parent().addClass('active')

      mainMenuLI = $(this).parents('ul.submenu-list').prev('.submenu')
      if (mainMenuLI.attr('class')) != undefined
        $(this).parents('ul.submenu-list').css('display', 'block')
        mainMenuLI.addClass('active')
  return

# This is the handler for the hiding/showing of the
# submenu of Articles in the Admin Sidebar
$(document).on 'click', '.submenu', (event) ->
  event.preventDefault()
  $this = $(this)

  if $this.hasClass('open')
    $this.removeClass('open')
    $this.next('ul.submenu-list').slideUp()
  else
    $this.addClass('open')
    $this.next('ul.submenu-list').slideDown()
