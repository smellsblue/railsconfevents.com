$(document).on "input", ".row-coordinator:last input", ->
    html = tmpl("new-coordinator-template", rowSize: $(".row-coordinator").size())
    $(@).parents(".row-coordinator:first").after(html)

$(document).on "change", "input[name='signups_enabled']", ->
    if $(@).is(":checked")
      $("#signups-content").collapse("show")
    else
      $("#signups-content").collapse("hide")

$(document).on "change", ".signups_question_style", ->
    element = $(@)
    row = $(@).parents(".row-signups-question:first")
    row.find(".signups-question-content-#{element.data("index")}").hide()
    row.find(".signups-question-content-#{element.data("index")}[data-signups-question-style='#{element.val()}']").show()

$(document).on "click", "#add-signups-question", (e) ->
    e.preventDefault()
    rowSize = $(".row-signups-question").size()
    html = tmpl("new-signups-question-template", rowSize: rowSize)
    newRow = $(html)
    style = newRow.find(".signups_question_style").val()
    newRow.find(".signups-question-content-#{rowSize}[data-signups-question-style='#{style}']").show()
    $("#signups-questions-container").append(newRow)

$(document).on "click", ".add-signups-question-dropdown-option", (e) ->
    e.preventDefault()
    element = $(@)
    container = $(element.data("target"))
    index = element.data("index")
    container.append """
      <div class="col-xs-12">
        <div class="form-group">
          <input type="text" class="form-control" name="signups_question_dropdown_option[#{index}][]" placeholder="Enter a dropdown option." />
        </div>
      </div>
    """
