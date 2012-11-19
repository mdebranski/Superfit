#= require jquery.min
#= require underscore-min
#= require jqtouch.min
#= require jqtouch-jquery.min
#= require moment.min
#= require spine/spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require_tree ./lib
#= require hamlcoffee
#= require_tree ./superfit/models
#= require_tree ./superfit/controllers
#= require_tree ./superfit/views

class AppInit
  constructor: ->
    $.get("/models").success (data) ->
      Wod.refresh(data.wods)
      Category.refresh(data.categories)
      new Superfit(el: $('body'))

      window.jQT = new $.jQTouch
        icon: 'jqtouch.png'
        icon4: 'jqtouch4.png'
        addGlossToIcon: false
        startupScreen: 'jqt_startup.png'
        statusBar: 'black-translucent'
        preloadImages: []

$ -> new AppInit()
