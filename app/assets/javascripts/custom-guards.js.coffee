$ = jQuery

$.guards.name("railsConf2015").message("Valid dates: 4/18 - 4/26.").using (value, element) ->
    value = $.trim value

    # Let dateUS handle it if this fails
    unless $.guards.isValidDateUS(value)
        return true

    match = /^(\d+)\/(\d+)\/(\d+)$/.exec value
    month = parseInt match[1], 10
    day = parseInt match[2], 10
    year = parseInt match[3], 10

    unless month == 4
        return false

    unless day >= 18 && day <= 26
        return false

    unless year == 2015
        return false

    true
