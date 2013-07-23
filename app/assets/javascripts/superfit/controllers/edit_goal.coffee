class Superfit.EditGoal extends Superfit.SearchWods

  searchType: 'goal'

  templateName: 'edit_goal'

  elements:
    '.wods-search': 'wodsSearch'
    '.wods-browse': 'wodsBrowse'
    '.no-matches': 'noMatches'
    'input.search-text': 'searchEl'
    'form': 'form'
    '.score-container .sub-header': 'scoreLabel'

  events:
    'keyup input.search-text': 'search'
    'tap input.search-text': 'search'
    'tap .wods-browse li a.browse': 'browseWods'
    'submit form': 'submit'

  constructor: ->
    super
    Goal.bind 'new', @newGoal
    @render()

    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in'
        @goal_id = null
        @wod = null
        @wods = null
        @wods_type = null
      if data.direction == 'in' and @goal_id = @el.data('referrer')?.data('id')
        @render()

  newGoal: (wod) =>
    if wod
      @wod = wod
      @render()
    else
      @goal_id = null
      @wod = null
      @wods = null
      @wods_type = null
      @render()

  browseWods: (e) ->
    @wods_type = $(e.target).closest('li').data('type')
    @render()

    wods = Wod.byType(@wods_type)
    @wodsBrowse.html('')
    for wod in wods
      item = new Superfit.WodItem(wod: wod, type: 'goal')
      @wodsBrowse.append item.render()

  search: (e) -> super(e, @wods_type)

  render: ->
    if @goal_id
      @templateName = 'edit_goal'
      goal = Goal.find(@goal_id)
      wod = Wod.find(goal.wod_id)
      super(goal: goal, wod: wod)
      @changeMethod()

    else if @wod
      @templateName = 'edit_goal'
      super(wod: @wod, user: User.first())
      @changeMethod()

    else if @wods
      @templateName = 'create_goal'
      super(wods_type: @wods_type)

    else
      @templateName = 'create_goal'
      super

    @initSpinners()
    @initValidation()

  initSpinners: ->
    @$('input[type=number]').spinner()

  initValidation: ->
    @form.validate
      submitHandler: @submit

  changeMethod: ->
    @$('.score').hide()
    @$('.score input').attr('disabled', true)
    method = @wod.scoring_method
    @$(".#{method}.score").show().attr('disabled', false)
    @$(".#{method}.score input").removeAttr('disabled')
    @scoreLabel.text "Enter Goal"

  submit: =>
    data = @form.serializeObject()
    data.wod_id = parseInt(data.wod_id)
    data.score = if data.score then parseInt(data.score) else parseInt(data.weight)
    data.min = parseInt(data.min)
    data.sec = parseInt(data.sec)
    data.reps = parseInt(data.reps)
    data.reps = parseInt(data.reps)
    data.start_date = moment().valueOf()
    data.last_update = moment().valueOf()

    if data.goal_id
      goal = Goal.find(data.goal_id)
      goal.updateAttributes(data)
    else
      goal = Goal.create(data)
      last = _.last WodEntry.byWodId(goal.wod_id)
      if last && goal.isMatch(last)
        goal.newEntry(last)
      else
        goal.start_score = 0
        goal.save()

    jQT.goTo('#goal-detail', jQT.settings.defaultTransition)
