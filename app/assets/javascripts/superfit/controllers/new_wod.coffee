class Superfit.NewWod extends Spine.Controller
  templateName: 'new_wod'

  constructor: ->
    super
    Wod.bind 'new', @updateNewWod

  updateNewWod: (wod) =>
    @wod = wod
    @render(wod: @wod)
