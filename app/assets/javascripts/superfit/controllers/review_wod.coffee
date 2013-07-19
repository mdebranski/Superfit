class Superfit.ReviewWod extends Spine.Controller

  elements:
    '.chart': 'chart'

  events:
    'tap .delete': 'deleteWod'
    'tap .history a': 'history'

  constructor: ->
    super
    WodEntry.bind 'create', @updateReviewWod
    WodEntry.bind 'update', @updateReviewWod

    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in' and referrer = @el.data('referrer')
        @el.data('referrer', null)
        id = referrer.data('id')
        entry = WodEntry.find(id)
        @updateReviewWod(entry)

  updateReviewWod: (entry) =>
    @wod = Wod.find(entry.wod_id) if entry.wod_id
    @entry = entry

    if entry.wod_id?
      @pastEntries = WodEntry.history(@wod)

    @render(wod: @wod, entry: @entry, pastEntries: @pastEntries)

    if @wod.method == 'pass_fail'
      @chart.hide()
    else
      Superfit.Chart.wodChart(@chart, @wod.history(), @wod.scoring_method)

  deleteWod: ->
    @entry.destroy()

  history: (e) ->
    id = $(e.target).closest('a').data('id')
    entry = WodEntry.find(id)
    @updateReviewWod(entry)
