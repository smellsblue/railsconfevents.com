$(document).on "input", ".new-coordinator:last input", ->
    html = tmpl("new-coordinator-template", rowSize: $(".new-coordinator").size())
    $(@).parents(".new-coordinator:first").after(html)
