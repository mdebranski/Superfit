#= require jquery.min
#= require jquery_ujs
#= require underscore-min
#= require underscore.string.min
#= require jqtouch.min
#= require jqtouch-jquery.min
#= require jquery.flot
#= require jquery.flot.resize
#= require jquery.flot.time
#= require jquery.flot.tooltip.min
#= require jquery.makeItRetina.min
#= require jquery.validate.min
#= require jquery.serialize-object
#= require jquery.ui.spinner
#= require timeago
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

  @NO_CHART_DATA = "<li class='no-data'>Not enough data to display chart</li>"
  @controllers: {}

  elements:
    '.page#get-started-step3': 'start'
    '.page#home': 'home'
    '.page#goals': 'goals'
    '.page#goal-detail': 'goalDetail'
    '.page#edit-goal': 'editGoal'
    '.page#records': 'records'
    '.page#edit-record': 'editRecord'
    '.page#record-detail': 'recordDetail'
    '.page#add-wod': 'addWod'
    '.page#browse-wods': 'browseWods'
    '.page#edit-wod': 'editWod'
    '.page#review-wod': 'reviewWod'
    '.page#calendar': 'calendar'
    '.page#edit-profile': 'editProfile'
    '.page#edit-profile-gym': 'editProfileGym'
    '.page#profile': 'profile'
    '.page#about': 'about'

  events:
    'pageAnimationStart .page': 'onPageTransition'

  constructor: ->
    super

    user = User.first()
    @render(user: user)

    new Superfit.Navigation()
    new Superfit.Start(el: @start) unless user
    new Superfit.Home(el: @home)
    new Superfit.Goals(el: @goals)
    new Superfit.GoalDetail(el: @goalDetail)
    new Superfit.EditGoal(el: @editGoal)
    new Superfit.Records(el: @records)
    new Superfit.EditRecord(el: @editRecord)
    new Superfit.RecordDetail(el: @recordDetail)
    new Superfit.AddWod(el: @addWod)
    new Superfit.BrowseWods(el: @browseWods)
    new Superfit.EditWod(el: @editWod)
    new Superfit.ReviewWod(el: @reviewWod)
    new Superfit.Calendar(el: @calendar)
    new Superfit.EditProfile(el: @editProfile)
    new Superfit.EditProfileGym(el: @editProfileGym)
    new Superfit.Profile(el: @profile)
    new Superfit.About(el: @about)

    $(@el).timeago()
    Superfit.bind 'timeago', => $(@el).timeago('refresh')

    _.defer -> $.makeItRetina('retinaBackgrounds': true);
    _.defer -> jQT.goTo('#get-started-step1', jQT.settings.defaultTransition) unless user

    @log "Registering listeners..."
    document.addEventListener "deviceready", @loadAnalytics, false
    document.addEventListener "pause", @onPause, false
    document.addEventListener "resume", @onResume, false

  loadAnalytics: =>
    if @gaPlugin = window.plugins?.gaPlugin
      @gaPlugin.init(@gaSuccess, @gaError, "UA-40739445-2", 10)

  onPause: =>
    @log "Pausing..."
    try
      SavedState.destroyAll()
      if active = Superfit.activeController
        state = if active.state? then active.state() else {}
        savedState = SavedState.create(controller: active.className(), state: state)
        @log "Saved state: #{JSON.stringify(savedState)}"
    catch error
      @log "Error pausing: #{error}"

  onResume: =>
    _.defer -> alert "Resuming..."
    try
      SavedState.fetch()
      if savedState = SavedState.first()
        _.defer -> alert "Resuming for controller: '#{savedState.controller}'; State: #{JSON.stringify(savedState.state)}"
        controller = Superfit.controllers[savedState.controller]
        controller.resume(savedState.state) if controller.resume?
        jQT.goTo(controller.el)
    catch error
      @log error
      _.defer -> alert "Error resuming: #{error}"

  gaSuccess: =>
    @updateUserVariables()
    User.bind 'create update', @updateUserVariables
    @gaPlugin.trackPage @trackPageSuccess, @trackPageError, "index.html"

  gaError: (msg) =>
    @log "Analytics failed to load: #{msg}"

  onPageTransition: (e, data) =>
    if data.direction == 'in'
      Superfit.activeController = null
      pageId = $(e.target).attr('id')
      @log "Tracking page: #{pageId}"
      if @gaPlugin?
        @gaPlugin.trackPage @trackPageSuccess, @trackPageError, pageId

  trackPageSuccess: =>
    @log "Track page success"

  trackPageError: (msg) =>
    @log "Track page error: #{msg}"

  updateUserVariables: =>
    if user = User.first()
      @gaPlugin.setVariable(@setVariableSuccess, @setVariableError, 1, user.email)
      @gaPlugin.setVariable(@setVariableSuccess, @setVariableError, 2, user.newsletter)
      @gaPlugin.setVariable(@setVariableSuccess, @setVariableError, 3, user.gender)
      @gaPlugin.setVariable(@setVariableSuccess, @setVariableError, 4, user.gym)

  setVariableSuccess: =>
    # Do nothing

  setVariableError: (msg) =>
    @log "Error setting variable: #{msg}"

window.Superfit = Superfit

$ ->
  User.fetch()
  Wod.fetch()
  Category.fetch()
  WodsVersion.fetch()
  WodEntry.fetch()
  Goal.fetch()

  $.get 'wods_version.txt', (latest_version) ->
    latest_version = latest_version.trim()
    wods_version = WodsVersion.first() || new WodsVersion()

    console.log "WODs version - latest: #{latest_version}, current: #{wods_version.version}"

    if wods_version.needs_update(latest_version)
      console.log "WODs Updating..."
      $.get 'wods.txt', (result) ->
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
        Wod.trigger('refresh')
        console.log "#{Wod.all().length} WODs updated to version #{latest_version}"

  window.superfit = new Superfit(el: $('body'))

  window.jQT = new $.jQTouch
    icon: 'jqtouch.png'
    icon4: 'jqtouch4.png'
    addGlossToIcon: false
    startupScreen: 'jqt_startup.png'
    statusBar: 'black-translucent'
    preloadImages: []
