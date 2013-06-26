class Superfit.EditProfile extends Spine.Controller

  templateName: 'edit_profile'

  elements:
    'form': 'form'


  constructor: ->
    super

    user = User.first()
    @render(user: user) if user?
    User.bind 'create update', (user) => @render(user: user)
    @form.validate
      submitHandler: @submit


  submit: =>
    data = @form.serializeObject()

    @log "Form data", data

    user = User.first()
    user.updateAttributes(data)



    jQT.goTo('#profile', jQT.settings.defaultTransition)
