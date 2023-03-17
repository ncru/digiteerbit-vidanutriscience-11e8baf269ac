$ ->

  $(document).on "click", '.btn-fb', (event) ->
    $this = $(this)
    $this.addClass("disabled").html("Signing with <i class='fa fa-facebook ml-5'/>").blur();
