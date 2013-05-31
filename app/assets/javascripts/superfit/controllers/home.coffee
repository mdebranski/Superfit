class Superfit.Home extends Superfit.SearchWods

  elements:
    '.chart': 'chart'

  events:
    'tap .prev-day': 'prevDay'
    'tap .next-day': 'nextDay'
    'tap .pulldown': -> Superfit.trigger('navigation')
    'tap .date': 'openCalendar'

  constructor: ->
    super
    Superfit.currentDate = @today()
    @render()

    Superfit.bind 'changeDate', @changeDate
    WodEntry.bind 'change', => @render()

  render: ->
    entries = WodEntry.byDate(Superfit.currentDate)
    super(currentDate: Superfit.currentDate, entries: entries, today: @today())
    @initCharts()

  initCharts: ->
    data = [[[0,0], [1,1], [2,3], [3,8], [4,15]]]
    options =
      xaxis:
        labelWidth: 40
    $.plot @chart, data, options

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
