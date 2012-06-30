#= require jquery.min
#= require underscore-min
#= require spine/spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require_tree ./lib
#= require hamlcoffee
#= require_tree ./superfit/models
#= require_tree ./superfit/controllers
#= require_tree ./superfit/views

$(document).bind "mobileinit", () ->
#  $.mobile.ajaxEnabled = false;
#  $.mobile.linkBindingEnabled = false;
#  $.mobile.hashListeningEnabled = false;
#  $.mobile.pushStateEnabled = false;

  $.mobile.defaultPageTransition = 'slide'
  $.mobile.autoInitializePage = false

class AppInit
  constructor: ->
    $.get("/models").success (data) ->
      Wod.refresh(data.wods)
      Category.refresh(data.categories)
      new Index(el: $('body'))

      if (document.location.hash == "")
          document.location.hash = "#home"

      $.mobile.initializePage()

      new NoClickDelay($('body'))

$ -> new AppInit()