class Superfit.Goals extends Spine.Controller

  events:
    'tap .filter-navigation a': 'navigateType'
    'tap .add-goal': -> Goal.trigger('new')

  constructor: ->
    super
    @type = 'in_progress'
    @render()

    Goal.bind 'change', => @render()
    WodEntry.bind 'create update', (entry) ->
      goals = Goal.byWodId(entry.wod_id)
      _.each goals, (goal) ->
        goal.newEntry(entry)

  render: ->
    if @type == 'in_progress'
      goals = Goal.inProgress()
    else
      goals = Goal.completed()
    super(goals: goals, type: @type)

    Superfit.trigger 'timeago'

  navigateType: (e) ->
    e.preventDefault()
    @type = $(e.target).data('type')
    @render()
