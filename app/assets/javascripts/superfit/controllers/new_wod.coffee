class Superfit.NewWod extends Spine.Controller
  templateName: 'enter_wod_score'

  constructor: ->
    super
    Wod.bind 'new', @updateNewWod

  updateNewWod: (wod) =>
    @wod = wod
    @render(wod: @wod)
