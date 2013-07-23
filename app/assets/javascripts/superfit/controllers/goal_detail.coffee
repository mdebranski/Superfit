class Superfit.GoalDetail extends Spine.Controller

  elements:
    '.chart': 'chart'
    '.chart-container': 'chartContainer'

  events:
    'tap .delete': 'delete'

  constructor: ->
    super
    Goal.bind 'create', @update
    Goal.bind 'update', @update

    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in' and referrer = @el.data('referrer')
        @el.data('referrer', null)
        id = referrer.data('id')
        goal = Goal.find(id)
        @update(goal)

  update: (goal) =>
    @wod = Wod.find(goal.wod_id)
    @goal = goal
    @pastEntries = @goal.entries()

    @render(wod: @wod, goal: @goal, startEntry: @goal.start_entry(), pastEntries: @pastEntries, showHistory: true)
    Superfit.trigger 'timeago'

    if @goal.history and @goal.history.length > 1
      Superfit.Chart.goalChart(@chart, @goal.history)
    else
      @chartContainer.replaceWith(Superfit.NO_CHART_DATA)

  delete: ->
    @goal.destroy()
