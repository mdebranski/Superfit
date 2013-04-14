class Superfit.ReviewWod extends Spine.Controller
  templateName: 'review_wod'

  constructor: ->
    super
    WodEntry.bind 'create', @updateReviewWod

    @el.bind "pageAnimationStart", =>
      if referrer = @el.data('referrer')
        id = referrer.data('id')
        entry = WodEntry.find(id)
        @updateReviewWod(entry)

  updateReviewWod: (entry) =>
    @wod = Wod.find(entry.wod_id)
    @entry = entry
    @render(wod: @wod, entry: @entry)
