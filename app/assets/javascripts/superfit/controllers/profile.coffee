class Superfit.Profile extends Spine.Controller

  constructor: ->
    super
    @render(user: User.first())
    User.bind 'update', @updateProfile

