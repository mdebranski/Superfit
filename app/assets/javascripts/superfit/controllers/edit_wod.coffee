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

  initValidation: ->
    @form.validate
      submitHandler: @submit

  updateNewWod: (wod) =>
    @wod = wod

    @templateName = if wod.type == 'Strength' then 'enter_strength_score' else 'enter_wod_score'

    @render(wod: @wod, user: User.first())
    @initValidation()

    @addSets() if @wod.type == 'Strength'

  updateEditEntry: (entry) ->
    @wod = Wod.find(entry.wod_id)

    @templateName = if @wod.type == 'Strength' then 'enter_strength_score' else 'enter_wod_score'

    @render(wod: @wod, entry: entry, user: User.first())
    @initValidation()

    @addSets(entry) if @wod.type == 'Strength'

  toInt: (numOrArray) ->
    return null unless numOrArray
    if typeof(numOrArray) == 'object'
      _.map numOrArray, (num) -> parseInt(num)
    else
      parseInt(numOrArray)

  ensureArray: (arrayOrNot) ->
    if typeof(arrayOrNot) == 'object'
      arrayOrNot
    else
      [arrayOrNot]

  submit: =>
    data = @form.serializeObject()

    attributes =
       wod_id: @wod.id
       score: @toInt(data.score)
       min: @toInt(data.min)
       sec: @toInt(data.sec)
       reps: @ensureArray @toInt(data.reps)
       weight: @ensureArray @toInt(data.weight)
       method: @wod.scoring_method
       type: data.type
       details: data.details
       date: Superfit.currentDate


    if data.entry_id
      entry = WodEntry.find(data.entry_id)
      entry.updateAttributes(attributes)
    else
      entry = WodEntry.create(attributes)

    jQT.goTo('#review-wod', jQT.settings.defaultTransition)

  addSets: (entry=null) ->
    unless entry
      @addSet()
    else
      _.each entry.reps, (reps, i) => @addSet(null, reps, entry.weight[i])

  addSet: (e=null, reps=null, weight=null) ->
    e.preventDefault() if e
    @set_number = @$('.set').length + 1

    html = JST['superfit/views/_set'](set_number: @set_number, reps: reps, weight: weight)
    @sets.append(html)
    @initSpinners()
