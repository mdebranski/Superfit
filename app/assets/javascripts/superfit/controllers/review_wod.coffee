class Superfit.ReviewWod extends Spine.Controller
  templateName: 'review_wod'

  events:
    'tap .delete': 'deleteWod'

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
    @render(wod: @wod, entry: @entry)

  deleteWod: ->
    @entry.destroy()
