class Superfit extends Spine.Controller
  templateName: 'superfit'

  elements:
    'ul#categories': 'categories'
    'ul#wods': 'wods'
    'ul#wods li': 'wodItems'
    'ul.wods-browse': 'wodsBrowse'
    '#no-matches': 'noMatches'
    'input#search-text': 'searchEl'
    '#add-wod': 'step1'
    '#new-wod': 'step2'

  events:
    'keyup input#search-text': 'search'
    'click input#search-text': 'search'
    'click #wods li': 'selectWod'

  constructor: ->
    super
    @render()
    @step1.on 'pageAnimationStart', => @searchEl.focus()
    @step2.on 'pageAnimationStart', => $('.wod-score input[name=custom-wod-label]').focus()

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
    @$('.wod-name', @step2).html("<span class='icon sprite-sf #{wod.type.toLowerCase()}'></span>#{wod.name}")
    @$('.wod-details p', @step2).html(workout)
    jQT.goTo('#new-wod', jQT.settings.defaultAnimation)

window.Superfit = Superfit
