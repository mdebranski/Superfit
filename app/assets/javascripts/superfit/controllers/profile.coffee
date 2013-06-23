class Superfit.Profile extends Spine.Controller

  constructor: ->
    super
    @render()
    User.bind 'update', @updateProfile

