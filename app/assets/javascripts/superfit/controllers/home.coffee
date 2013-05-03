class Superfit.Home extends Superfit.SearchWods

  events:
    'tap .prev-day': 'prevDay'
    'tap .next-day': 'nextDay'

  constructor: ->
    super
    Superfit.currentDate = moment().startOf('day').toDate()

    @render()

    Superfit.bind 'changeDate', @changeDate
    WodEntry.bind 'change', => @render()

  render: ->
    entries = WodEntry.byDate(Superfit.currentDate)
    super(currentDate: Superfit.currentDate, entries: entries)

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
