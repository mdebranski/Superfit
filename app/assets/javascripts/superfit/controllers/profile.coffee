class Superfit.Profile extends Spine.Controller

  constructor: ->
    super
    @render() if User.first()
    User.bind 'create update', @render


  render: =>
    super(user: User.first())
