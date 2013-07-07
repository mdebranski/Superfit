String::commafy = ->
  this.replace /(^|[^\w.])(\d{4,})/g, ($0, $1, $2) ->
    $1 + $2.replace /\d(?=(?:\d\d\d)+(?!\d))/g, "$&,"

String::present = -> @trim().length > 0

String::contains = (str) -> this.indexOf(str) != -1

String::truncate = (length, suffix = '...') ->
  if @length > length
    str = @.substring(0, length)
    str = str.substring(0, Math.min(str.length, str.lastIndexOf(" ")))
    if str.length == 0
      str = @.substring(0, length)
    str + suffix
  else
    @.toString()

Number::commafy = ->
  String(this).commafy()

Number::limit = (max) ->
  if this > max then "#{max}+".commafy() else this.commafy()

String::lpad = (length, strToPad = "0") ->
  str = this.toString()
  while (str.length < length)
    str = strToPad + str
  str

Number::lpad = (length, strToPad = "0") ->
  String(this).lpad(length, strToPad)

$.easing.easeOutCubic = (x, t, b, c, d) -> c*((t=t/d-1)*t*t + 1) + b

# Shims
unless String::trim then String::trim = -> @replace /^\s+|\s+$/g, ""
Array.prototype.some ?= (f) ->
  (return true if f x) for x in @
  return false

Array.prototype.every ?= (f) ->
  (return false if not f x) for x in @
  return true

class Utils
  @simpleFormat: (text) ->
    return '' if text == null
    text = text.toString()
    text = text.replace(/\r\n?/g, "\n") # \r\n and \r -> \n
    text = text.replace(/\n/g, '<br/>')

window.Utils = Utils


# Fix jQuery Validation bug: https://github.com/jzaefferer/jquery-validation/issues/423?source=c
`
$.validator.prototype.elements = function() {
    var validator = this;
    // select all valid inputs inside the form (no submit or reset buttons)
    return $(this.currentForm)
        .find("input")
        .not(":submit, :reset, :image, [disabled]")
        .not( this.settings.ignore )
        .filter(function() {
            !this.name && validator.settings.debug && window.console && console.error( "%o has no name assigned", this);
            return validator.objectLength($(this).rules());
        });
};
`
