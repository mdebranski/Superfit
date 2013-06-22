class Superfit.EditProfile extends Spine.Controller

  templateName: 'edit_profile'

  elements:
    'form': 'form'


  constructor: ->
    super
    @render(user: User.first())
    @form.validate
      submitHandler: @submit


  submit: =>
    data = @form.serializeObject()

    user = User.first()
    user.updateAttributes(data)



    jQT.goTo('#profile', jQT.settings.defaultTransition)
