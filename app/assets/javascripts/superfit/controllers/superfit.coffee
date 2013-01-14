class Superfit extends Spine.Controller
  templateName: 'superfit'

  elements:
    'ul#categories': 'categories'
    'ul#wods': 'wods'
    'ul#wods li': 'wodItems'
    'ul.wods-browse': 'wodsBrowse'
    '.no-matches': 'noMatches'
    'input#search-text': 'searchEl'
    '#add-wod': 'step1'
    '#new-wod': 'step2'
    '#login-form': 'loginForm'

  events:
    'keyup input#search-text': 'search'
    'tap input#search-text': 'search'
    'tap #wods li a': 'selectWod'

  navShowing: false

  constructor: ->
    super
    @render(user: User.first())
    @step1.on 'pageAnimationEnd', => @searchEl.focus()
    @step2.on 'pageAnimationEnd', => $('.wod-score input[name=custom-wod-label]').focus()

    @loginForm.on 'ajax:success', => console.log "SUCCESS"
    @loginForm.on 'ajax:error', => console.log "ERROR"
    @loginForm.on 'ajax:complete', => console.log "COM"

    @navigation = $('#navigation').detach()
    $('.pulldown').on 'tap', @pulldown
    $('.page').on 'pageAnimationEnd', => @navShowing = false; @navigation.detach()

  @login: ->
    onLogin = (response) =>
      if response.authResponse
        $.get '/users/auth/facebook_access_token/callback', {access_token: response.authResponse.accessToken}, -> document.location.reload()
    FB.login(onLogin)

  pulldown: =>
    @log "Nav showing: #{@navShowing}"
    if @navShowing
      @navShowing = false
      @navigation.slideUp => @navigation.detach()
    else
      @navShowing = true
      @navigation.css('display', 'none')
      @navigation.prependTo('.current')
      @navigation.slideDown()

  search: (e) ->
    value = $(e.target).val()

    if value? and value.length > 0
      @wodsBrowse.hide()
      @wods.fadeIn()
      _.each $('li', @wods), (el) ->
        el = $(el)
        if el.text().toLowerCase().indexOf(value.toLowerCase()) == -1
          el.hide()
        else
          el.show()
      if $('li:visible', @wods).length == 0
        @noMatches.fadeIn()
      else
        @noMatches.hide()
    else
      @wods.hide()
      @noMatches.hide()
      @wodsBrowse.fadeIn()
      $('li', @wods).show()

  selectWod: (e) ->
    id = $(e.target).closest('li').data('id')
    wod = Wod.find(id)
    workout = wod.workout_male.replace(/\n/g, '<br/>')
    console.log "HERE"
    @$('.wod-name', @step2).html("<span class='icon sprite-sf #{wod.type.toLowerCase()}'></span>#{wod.name}")
    @$('.wod-details p', @step2).html(workout)
    jQT.goTo('#new-wod', jQT.settings.defaultAnimation)

window.Superfit = Superfit
