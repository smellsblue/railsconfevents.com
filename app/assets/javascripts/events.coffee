$(document).on "input", ".row-coordinator:last input", ->
    html = tmpl("new-coordinator-template", rowSize: $(".row-coordinator").size())
    $(@).parents(".row-coordinator:first").after(html)
