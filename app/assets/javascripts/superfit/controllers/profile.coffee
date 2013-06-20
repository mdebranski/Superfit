class Superfit.Profile extends Spine.Controller

  events:
    'tap .pulldown': -> Superfit.trigger('navigation')

  constructor: ->
    super
    @render()
