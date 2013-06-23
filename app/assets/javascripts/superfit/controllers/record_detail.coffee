class Superfit.RecordDetail extends Spine.Controller
  templateName: 'record_detail'

  constructor: ->
    super
    Wod.bind 'newRecord', @update

    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in' and referrer = @el.data('referrer')
        @el.data('referrer', null)
        id = referrer.data('id')
        wod = Wod.find(id)
        @update(wod)

  update: (wod) =>
    @wod = wod
    if @wod.personal_record?
      @pastEntries = WodEntry.history(@wod)
      @render(wod: @wod, pastEntries: @pastEntries)

