class Superfit.Profile extends Spine.Controller

  constructor: ->
    super
    @render()
    User.bind 'create update', => @render(user: User.first())


  render: ->
    super(user: User.first())
