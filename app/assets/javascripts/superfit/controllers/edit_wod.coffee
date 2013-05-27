class Superfit.EditWod extends Spine.Controller

  elements:
    'form': 'form'
    '.sets': 'sets'

  events:
    'tap .add-set': 'addSet'
    'submit form': 'submit'

  constructor: ->
    super
    Wod.bind 'new', @updateNewWod

    @el.bind "pageAnimationStart", =>
      if id = @el.data('referrer')?.data('id')
        entry = WodEntry.find(id)
        @updateEditEntry(entry)

  render: ->
    super
    @initSpinners()

  initSpinners: ->
    @$('input[type=number]').spinner()

  updateNewWod: (wod) =>
    @wod = wod

    @templateName = if wod.type == 'Strength' then 'enter_strength_score' else 'enter_wod_score'

    @render(wod: @wod, user: User.first())
    @form.validate
      submitHandler: @submit

    @addSets() if @wod.type == 'Strength'

  updateEditEntry: (entry) ->
    @wod = Wod.find(entry.wod_id)

    @templateName = if @wod.type == 'Strength' then 'enter_strength_score' else 'enter_wod_score'

    @render(wod: @wod, entry: entry, user: User.first())
    @form.validate
      submitHandler: @submit

    @addSets() if @wod.type == 'Strength'

  submit: =>
    data = @form.serializeObject()
    _.extend data, {date: Superfit.currentDate, method: @wod.scoring_method}

    if data.entry_id
      entry = WodEntry.find(data.entry_id)
      entry.updateAttributes(data)
    else
      entry = WodEntry.create(data)

    jQT.goTo('#review-wod', jQT.settings.defaultTransition)

  addSets: ->
    @addSet()

  addSet: (e=null) ->
    e.preventDefault() if e
    @set_number = @$('.set').length + 1

    html = JST['superfit/views/_set'](set_number: @set_number)
    @sets.append(html)
    @initSpinners()
