class Superfit.Records extends Spine.Controller

  events:
    'tap .pulldown': -> Superfit.trigger('navigation')
