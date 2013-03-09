#= require jquery.min
#= require jquery_ujs
#= require underscore-min
#= require jqtouch.min
#= require jqtouch-jquery.min
#= require jquery.makeItRetina.min
#= require moment.min
#= require spine/spine
#= require spine/manager
#= require spine/local
#= require spine/route
#= require_tree ./lib
#= require hamlcoffee
#= require_self
#= require_tree ./superfit/lib
#= require_tree ./superfit/models
#= require_tree ./superfit/controllers
#= require_tree ./superfit/views

class Superfit extends Spine.Controller
  templateName: 'superfit'

  elements:
    '.page#add-wod': 'addWod'
    '.page#browse-wods': 'browseWods'
    '.page#new-wod': 'newWod'

  constructor: ->
    super

    user = User.first()
    user = new User() unless user

    @render(user: user)

    new Superfit.AddWod(el: @addWod)
    new Superfit.BrowseWods(el: @browseWods)
    new Superfit.NewWod(el: @newWod)

    _.defer -> $.makeItRetina();

    @navigation = $('#navigation').detach()
    $('.pulldown').on 'tap', @pulldown
    $('.page').on 'pageAnimationEnd', => @navigation.removeClass('active'); @navigation.detach()

  pulldown: =>
    if @navigation.is('.active')
      @navigation.removeClass('active')
      hide = => @navigation.hide()
      _.delay hide, 1000
    else
      @navigation.prependTo('.current')
      @navigation.show()
      _.defer => @navigation.addClass('active')

window.Superfit = Superfit

$ ->
  User.fetch()
  Wod.fetch()
  Category.fetch()

  if Wod.all().length == 0
    $.get '/wods.txt', (result) ->
      wods = $.parseJSON(result)
      Wod.refresh(wods)

  new Superfit(el: $('body'))

  window.jQT = new $.jQTouch
    icon: 'jqtouch.png'
    icon4: 'jqtouch4.png'
    addGlossToIcon: false
    startupScreen: 'jqt_startup.png'
    statusBar: 'black-translucent'
    preloadImages: []
