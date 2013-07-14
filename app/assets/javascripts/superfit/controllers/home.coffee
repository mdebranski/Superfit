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
    @initCharts()

  initCharts: ->
    if @goal?.history
      data = [@goal.history]
      options =
        xaxis:
          mode: 'time'
          labelWidth: 40
        yaxis:
          min: 0
          max: 100
          minTickSize: 1
          tickFormatter: (value) -> "#{value}%"
        series:
          color: 'rgba(78, 163, 227, 0.95)'
          lines:
            show: true
            lineWidth: 1
            fill: true
            fillColor: 'rgba(78, 163, 227, 0.15)'
          points:
            show: true
            borderWidth: 1
          shadowSize:0
        grid:
          borderWidth:0
          clickable: true
          color:  'rgba(0, 0, 0, 0.2)'
          labelMargin:20

      $.plot @chart, data, options

    else
      @chart.hide()

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
