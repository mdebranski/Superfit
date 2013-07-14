class Superfit.Home extends Spine.Controller

  elements:
    '.chart': 'chart'

  events:
    'tap .prev-day': 'prevDay'
    'tap .next-day': 'nextDay'
    'tap .date': 'openCalendar'

  constructor: ->
    super
    Superfit.currentDate = @today()
    @render()

    Superfit.bind 'changeDate', @changeDate
    WodEntry.bind 'change', => @render()
    Goal.bind 'change', => @render()

  render: ->
    entries = WodEntry.byDate(Superfit.currentDate)
    @goal = Goal.lastUpdated()
    super(currentDate: Superfit.currentDate, entries: entries, goal: @goal, today: @today())
    Superfit.Chart.goalChart(@chart, @goal?.history)

  today: ->
    moment().startOf('day').toDate()

  changeDate: (date) =>
    Superfit.currentDate = date
    @render()
    jQT.goTo('#home', 'pop')

  prevDay: =>
    previous = moment(Superfit.currentDate).subtract('days', 1).toDate()
    @changeDate(previous)

  nextDay: =>
    next = moment(Superfit.currentDate).add('days', 1).toDate()
    @changeDate(next)

  openCalendar: ->
    jQT.goTo('#calendar', 'pop')
