class Superfit.Home extends Superfit.SearchWods

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
