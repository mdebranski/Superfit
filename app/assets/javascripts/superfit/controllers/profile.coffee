class Superfit.Profile extends Spine.Controller

  constructor: ->
    super
    @render()
    User.bind 'update', => @render()

  render: ->
    super(user: User.first())
