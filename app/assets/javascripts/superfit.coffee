#= require jquery.min
#= require jquery_ujs
#= require underscore-min
#= require underscore.string.min
#= require jqtouch.min
#= require jqtouch-jquery.min
#= require jquery.flot
#= require jquery.flot.resize
#= require jquery.makeItRetina.min
#= require jquery.validate.min
#= require jquery.serialize-object
#= require jquery.ui.spinner
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
    '.page#get-started-step3': 'start'
    '.page#home': 'home'
    '.page#goals': 'goals'
    '.page#records': 'records'
    '.page#edit-record': 'editRecord'
    '.page#add-wod': 'addWod'
    '.page#browse-wods': 'browseWods'
    '.page#edit-wod': 'editWod'
    '.page#review-wod': 'reviewWod'
    '.page#calendar': 'calendar'
    '.page#edit-profile': 'editProfile'
    '.page#profile': 'profile'

  constructor: ->
    super

    user = User.first()
    @render(user: user)

    new Superfit.Start(el: @start) unless user
    new Superfit.Home(el: @home)
    new Superfit.Goals(el: @goals)
    new Superfit.Records(el: @records)
    new Superfit.EditRecord(el: @editRecord)
    new Superfit.AddWod(el: @addWod)
    new Superfit.BrowseWods(el: @browseWods)
    new Superfit.EditWod(el: @editWod)
    new Superfit.ReviewWod(el: @reviewWod)
    new Superfit.Calendar(el: @calendar)
    new Superfit.EditProfile(el: @editProfile)
    new Superfit.Profile(el: @profile)


    $('.app-container').on 'click', '.pulldown', @pulldown
    @navigation = $('#navigation').detach()
    $('.page').on 'pageAnimationEnd', => $('.pulldown').removeClass('open'); @navigation.removeClass('active'); @navigation.detach()

    _.defer -> $.makeItRetina();
    _.defer -> jQT.goTo('#get-started-step1', jQT.settings.defaultTransition) unless user

  pulldown: (e) =>
    if @navigation.is('.active')
      $(e.target).removeClass('open')
      @navigation.removeClass('active')
    else
      $(e.target).addClass('open')
      @navigation.prependTo('.current')
      _.defer => @navigation.addClass('active')

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

        _.each wods, (wod_hash) ->
          id = wod_hash.id
          if Wod.exists(id)
            wod = Wod.find(id)
            console.log "Updating wod #{id} with:", wod_hash
            wod.updateAttributes(wod_hash)
          else
            console.log "Creating wod #{wod_hash.id} with:", wod_hash
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

