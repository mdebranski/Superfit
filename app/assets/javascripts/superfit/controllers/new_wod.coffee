class Superfit.NewWod extends Spine.Controller
  templateName: 'enter_wod_score'

  elements:
    'form': 'form'

  events:
    'submit form': 'submit'

  constructor: ->
    super
    Wod.bind 'new', @updateNewWod
    @log @form.serializeArray()
    @form.validate
      submitHandler: @submit

  updateNewWod: (wod) =>
    @wod = wod
    @render(wod: @wod)

  submit: =>
    data = @form.serializeObject()
    _.extend data, {date: Superfit.currentDate}
    entry = new WodEntry(data)
    entry.save()

    jQT.goTo('#review-wod', jQT.settings.defaultTransition)
