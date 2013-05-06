class Superfit.NewWod extends Spine.Controller

  elements:
    'form': 'form'
    '.sets': 'sets'

  events:
    'tap .add-set': 'addSet'
    'submit form': 'submit'

  constructor: ->
    super
    Wod.bind 'new', @updateNewWod

  updateNewWod: (wod) =>
    @wod = wod
    console.log wod
    @templateName = if wod.type == 'Strength' then 'enter_strength_score' else 'enter_wod_score'

    @render(wod: @wod)
    @form.validate

      submitHandler: @submit

    @addSets() if @wod.type == 'Strength'

  submit: =>
    data = @form.serializeObject()
    _.extend data, {date: Superfit.currentDate}
    entry = new WodEntry(data)
    entry.save()

    jQT.goTo('#review-wod', jQT.settings.defaultTransition)

  addSets: ->
    @addSet()

  addSet: (e=null) ->
    e.preventDefault() if e
    @set_number or= 0
    @set_number += 1

    html = JST['superfit/views/_set'](set_number: @set_number)
    @sets.append(html)
