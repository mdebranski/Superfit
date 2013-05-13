#= require jquery.min
#= require jquery_ujs
#= require underscore-min
#= require jqtouch.min
#= require jqtouch-jquery.min
#= require jquery.makeItRetina.min
#= require jquery.validate.min
#= require jquery.serialize-object
#= require moment.min
#= require spine/spine
#= require spine/manager
#= require spine/local
#= require spine/route
#= require_tree ./lib
#= require hamlcoffee
#= require jquery.calendario
#= require_self
#= require_tree ./superfit/lib
#= require_tree ./superfit/models
#= require_tree ./superfit/controllers
#= require_tree ./superfit/views

class Superfit extends Spine.Controller
  @extend Spine.Events

  templateName: 'superfit'

  elements:
    '.page#home': 'home'
    '.page#add-wod': 'addWod'
    '.page#browse-wods': 'browseWods'
    '.page#edit-wod': 'editWod'
    '.page#review-wod': 'reviewWod'
    '.page#calendar': 'calendar'
    '.date': 'dateEl'

  events:
    'click .date': 'openCalendar'
    'click #get-started': 'createUser'

  constructor: ->
    super

    user = User.first()
    @render(user: user)

    new Superfit.Home(el: @home)
    new Superfit.AddWod(el: @addWod)
    new Superfit.BrowseWods(el: @browseWods)
    new Superfit.EditWod(el: @editWod)
    new Superfit.ReviewWod(el: @reviewWod)
    new Superfit.Calendar(el: @calendar)

    _.defer -> $.makeItRetina();

    @navigation = $('#navigation').detach()
    $('.pulldown').on 'tap', @pulldown
    $('.page').on 'pageAnimationEnd', => @navigation.removeClass('active'); @navigation.detach()

  openCalendar: ->
    jQT.goTo('#calendar', 'pop')

  pulldown: =>
    if @navigation.is('.active')
      @navigation.removeClass('active')
      hide = => @navigation.hide()
      _.delay hide, 1000
    else
      @navigation.prependTo('.current')
      @navigation.show()
      _.defer => @navigation.addClass('active')

  createUser: ->
    gender = $('input[name=gender]:checked').val()
    User.create(gender: gender)

window.Superfit = Superfit

$ ->
  User.fetch()
  Wod.fetch()
  Category.fetch()
  WodsVersion.fetch()
  WodEntry.fetch()

  $.get '/wods_version.txt', (latest_version) ->
    latest_version = latest_version.trim()
    wods_version = WodsVersion.first() || new WodsVersion()

    console.log "WODs version - latest: #{latest_version}, current: #{wods_version.version}"

    if wods_version.needs_update(latest_version)
      console.log "WODs Updating..."
      $.get '/wods.txt', (result) ->
        wods = $.parseJSON(result)

        Wod.destroyAll()
        _.each wods, (wod_hash) ->
          wod = new Wod(wod_hash)
          wod.save()

        wods_version.version = latest_version
        wods_version.save()
        console.log "#{Wod.all().length} WODs updated to version #{latest_version}"

  new Superfit(el: $('body'))

  window.jQT = new $.jQTouch
    icon: 'jqtouch.png'
    icon4: 'jqtouch4.png'
    addGlossToIcon: false
    startupScreen: 'jqt_startup.png'
    statusBar: 'black-translucent'
    preloadImages: []

