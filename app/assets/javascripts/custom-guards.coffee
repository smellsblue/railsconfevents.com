$ = jQuery

$.fn.getDate = ->
    value = $.trim @val()
    return unless $.guards.isValidDateUS(value)
    match = /^(\d+)\/(\d+)\/(\d+)$/.exec value
    month = parseInt match[1], 10
    day = parseInt match[2], 10
    year = parseInt match[3], 10
    new Date("#{year}-#{month}-#{day} 0:00:00")

conferenceDateGuard = $.guards.name("conferencedate").using (value, element) ->
    $element = $ element
    value = $element.getDate()

    # Let dateUS handle if the date isn't valid
    unless value?
        return true

    if value.getFullYear() != parseInt($($element.data("conferencedate-year")).val(), 10)
        $element.data("conferencedate-error-message", "The conference year must match.")
        return false

    failureMessage = null

    $($element.data("conferencedate-greater-than")).each ->
        $otherElement = $(@)
        otherValue = $otherElement.getDate()
        return unless otherValue?

        if value < otherValue
            failureMessage = "This date must be greater than or equal to the #{$otherElement.data("conferencedate-label")}."
            return false

    if failureMessage?
        $element.data("conferencedate-error-message", failureMessage)
        return false

    $($element.data("conferencedate-less-than")).each ->
        $otherElement = $(@)
        otherValue = $otherElement.getDate()
        return unless otherValue?

        if value > otherValue
            failureMessage = "This date must be less than or equal to the #{$otherElement.data("conferencedate-label")}."
            return false

    if failureMessage?
        $element.data("conferencedate-error-message", failureMessage)
        return false

    true

conferenceDateGuard.messageFn (element) ->
    message = $(element).data("conferencedate-error-message")
    console.log message
    $("""<#{conferenceDateGuard.getTag()} class="#{conferenceDateGuard.getMessageClass()}"/>""").html(message)

$.guards.name("confDates").using (value, element) ->
    $element = $ element
    value = $element.getDate()

    # Let dateUS handle if the date isn't valid
    unless value?
        return true

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
