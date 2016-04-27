$(document).on "input", ".new-coordinator:last input", ->
    size = $(".new-coordinator").size()
    newRow = $("""<div class="row new-coordinator"></div>""")
    newRow.html $("#new-coordinator-row").html()

    newRow.find("[id]").each ->
        element = $(@)
        originalId = element.attr("id")
        element.attr("id", "#{originalId}-#{size}")
        newRow.find("[for='#{originalId}']").attr("for", "#{originalId}-#{size}")
        newRow.find("[aria-describedby='#{originalId}']").attr("aria-describedby", "#{originalId}-#{size}")

    unless newRow.find("hr").size > 0
        newRow.prepend("""<hr class="visible-xs-block" />""")

    $(@).parents(".new-coordinator:first").after(newRow)
