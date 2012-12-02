$(document).ready () ->
  $(window).resize () ->
    $('#stylesTest').html '#noShow { width:' + $(window).width() + 'px }'

