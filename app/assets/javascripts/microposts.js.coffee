$ ->
  $('.content').on('keyup keydown keypress change',->
    thisValueLength = $(this).val().length
    limit = 140
    if thisValueLength < limit
      $('.count').html(limit - thisValueLength).removeClass("text-danger")
    else
      $('.count').html(limit - thisValueLength).addClass("text-danger")
  ).keyup()