class Superfit.RecordDetail extends Spine.Controller
  templateName: 'record_detail'

  events:
    'tap .filter-navigation a': 'navigate'

  constructor: ->
    super
    Wod.bind 'recordDetail', @update

    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in' and referrer = @el.data('referrer')
        @el.data('referrer', null)
        id = referrer.data('id')
        wod = Wod.find(id)
        @update(wod)

  update: (wod, repMax=1) =>
    @wod = wod
    @repMax = repMax
    if @wod.personal_record?
      @pastEntries = WodEntry.history(@wod)
      @render(wod: @wod, pastEntries: @pastEntries, repMax: @repMax)

  navigate: (e) ->
    e.preventDefault()
    repMax = $(e.target).closest('a').data('rep-max')
    Wod.trigger 'goToRecord', @wod.id, repMax