class Superfit.Records extends Spine.Controller

  events:
    'tap .pulldown': -> Superfit.trigger('navigation')
    'tap .filter-navigation a': 'navigateType'

  currentType: 'strength'

  constructor: ->
    super
    @render()
    @updateTypes()

  navigateType: (e) ->
    e.preventDefault()
    @currentType = $(e.target).data('type')
    @updateTypes()

  updateTypes: ->
    @$("section:visible").hide()
    @$("section.#{@currentType}").fadeIn()
