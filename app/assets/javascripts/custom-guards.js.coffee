$ = jQuery

$.guards.name("confDates").using (value, element) ->
    value = $.trim value

    # Let dateUS handle it if this fails
    unless $.guards.isValidDateUS(value)
        return true

    match = /^(\d+)\/(\d+)\/(\d+)$/.exec value
    month = parseInt match[1], 10
    day = parseInt match[2], 10
    year = parseInt match[3], 10
    value = new Date("#{year}-#{month}-#{day} 0:00:00")
    $element = $ element

    if value < new Date("#{$element.data("valid-starting-at")} 0:00:00")
        return false

    if value > new Date("#{$element.data("valid-ending-at")} 0:00:00")
        return false

    true

$.guards.name("twitter").message("Invalid Twitter handle.").using (value, element) ->
    if value == ""
        return true

    /^[a-zA-Z0-9_]{1,15}$/.test value

$.guards.name("github").message("Invalid GitHub handle.").using (value, element) ->
    if value == ""
        return true

    if /--/.test(value)
        return false

    if /^-/.test(value)
        return false

    if /-$/.test(value)
        return false

    /^[a-zA-Z0-9-]{1,39}$/.test value
