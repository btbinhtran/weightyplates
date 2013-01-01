$(document).ready () ->
  $(window).resize () ->
    $('#stylesTest').html '#noShow { width:' + $(window).width() + 'px }'
  $('#close-button').click ->
    $('#flash_notice').remove()


