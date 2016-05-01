$(document).on "input", ".row-coordinator:last input", ->
    html = tmpl("new-coordinator-template", rowSize: $(".row-coordinator").size())
    $(@).parents(".row-coordinator:first").after(html)

$(document).on "change", "input[name='signups_enabled']", ->
    if $(@).is(":checked")
      $("#signups-content").collapse("show")
    else
      $("#signups-content").collapse("hide")
