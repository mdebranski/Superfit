class Superfit.ReviewWod extends Spine.Controller

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

  deleteWod: ->
    @entry.destroy()

  history: (e) ->
    id = $(e.target).closest('a').data('id')
    console.log(id)
    entry = WodEntry.find(id)
    @updateReviewWod(entry)
