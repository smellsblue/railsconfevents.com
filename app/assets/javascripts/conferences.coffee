$(document).on "click", "#header-preview", (e) ->
    e.preventDefault()
    $("#header-preview-content").html $("#header").val()
