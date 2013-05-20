class Superfit.Home extends Superfit.SearchWods

  events:
    'tap .prev-day': 'prevDay'
    'tap .next-day': 'nextDay'
    'tap .pulldown': 'pulldown'

  constructor: ->
    super
    Superfit.currentDate = @today()
    @render()

    Superfit.bind 'changeDate', @changeDate
    WodEntry.bind 'change', => @render()

    @navigation = $('#navigation').detach()
    $('.page').on 'pageAnimationEnd', => @navigation.removeClass('active'); @navigation.detach()

  render: ->
    entries = WodEntry.byDate(Superfit.currentDate)
    super(currentDate: Superfit.currentDate, entries: entries, today: @today())

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

  pulldown: =>
    if @navigation.is('.active')
      @navigation.removeClass('active')
      hide = => @navigation.hide()
      _.delay hide, 1000
    else
      @navigation.prependTo('.current')
      @navigation.show()
      _.defer => @navigation.addClass('active')
