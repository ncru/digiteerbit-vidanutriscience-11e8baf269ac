$ ->
  $(document).on 'click', '.post-tab a', (e) ->
    e.preventDefault()
    $this = $(this)
    parent = $this.parent()
    target = '#'+$this.attr('target')

    $('.tab-content').addClass('hidden')
    $('.post-tab li').removeClass('active')

    parent.addClass('active')
    $(target).removeClass('hidden')
    return
