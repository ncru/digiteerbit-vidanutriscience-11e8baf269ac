$(document).on "ready page:load", ->

  

  startSpinner = ->
    $("#overlay_loading").removeClass "hide_loading"
    $("#overlay_loading").addClass "loading"
  stopSpinner = ->
    $("#overlay_loading").addClass "hide_loading"
    $("#overlay_loading").removeClass "loading"
  document.addEventListener "page:fetch", startSpinner
  document.addEventListener "ready page:change", stopSpinner
  document.addEventListener "page:restore", stopSpinner
