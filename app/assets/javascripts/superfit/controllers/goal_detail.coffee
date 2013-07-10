class Superfit.GoalDetail extends Spine.Controller

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
    @pastEntries = WodEntry.history(@wod)

    @render(wod: @wod, goal: @goal, pastEntries: @pastEntries)
    Superfit.trigger 'timeago'

  delete: ->
    @goal.destroy()
