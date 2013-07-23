class Superfit.ReviewWod extends Spine.Controller

  elements:
    '.chart': 'chart'
    '.chart-container': 'chartContainer'

  events:
    'tap .delete': 'deleteWod'
    'tap .history a': 'history'

  constructor: ->
    super
    WodEntry.bind 'create', @updateReviewWod
    WodEntry.bind 'update', @updateReviewWod
    Goal.bind 'complete', (goal) => @completedGoal = goal

    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in' and referrer = @el.data('referrer')
        @el.data('referrer', null)
        id = referrer.data('id')
        entry = WodEntry.find(id)
        @updateReviewWod(entry)

  updateReviewWod: (entry) =>
    @wod = Wod.find(entry.wod_id) if entry.wod_id
    @entry = entry

    if entry.wod_id?
      @pastEntries = WodEntry.history(@wod)

      if entry.type
        @pastEntries = @pastEntries.filter (pastEntry) -> entry.type == pastEntry.type

    personalRecord = @wod.personal_record? and @entry.id == @wod.personal_record.entry_id
    @render(wod: @wod, entry: @entry, pastEntries: @pastEntries, completedGoal: @completedGoal, showHistory: @wod != null, personalRecord: personalRecord)

    @completedGoal = null

    - if @wod
      history = @wod.history()
      if @wod.method == 'pass_fail'
        @chart.hide()
      else if history and history.length > 1
        Superfit.Chart.wodChart(@chart, history, @wod.scoring_method)
      else
        @chartContainer.replaceWith(Superfit.NO_CHART_DATA)

  deleteWod: ->
    @entry.destroy()

  history: (e) ->
    id = $(e.target).closest('a').data('id')
    entry = WodEntry.find(id)
    @updateReviewWod(entry)
