class Superfit.EditProfile extends Spine.Controller

  templateName: 'edit_profile'

  elements:
    'form': 'form'

  events:
    'submit form': 'submit'

  constructor: ->
    super
    @render()
    @form.validate
      submitHandler: @submit


  submit: =>
    data = @form.serializeObject()

    user = User.first()
    user.updateAttributes(data)


    jQT.goTo('#profile', jQT.settings.defaultTransition)
