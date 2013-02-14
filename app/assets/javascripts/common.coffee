##= require jquery
##= require jquery_ujs

$(document).ready () ->

  $(window).resize () ->
    windowWidth = $(window).width()
    windowWidthInEms = windowWidth/16
    $('#stylesTest').html("#noShow { width: + #{windowWidthInEms} + em }")

  $('#close-button').click ->
    $('#flash_notice').fadeOut(250, ->
      $(this).remove()
    )
