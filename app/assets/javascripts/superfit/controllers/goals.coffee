class Superfit.Goals extends Spine.Controller

  events:
    'tap .pulldown': -> Superfit.trigger('navigation')

  constructor: ->
    super
    @render()
