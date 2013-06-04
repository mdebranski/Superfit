class Superfit.Calendar extends Spine.Controller

  elements:
    '.fc-calendar-container': 'calendarEl'
    '#custom-month': 'monthEl'
    '#custom-year': 'yearEl'

  events:
    'tap #custom-next': 'nextMonth'
    'tap #custom-prev': 'prevMonth'

  constructor: ->
    super
    @render()
    WodEntry.bind 'change', => @render()

  render: ->
    super

    reduceData = (acc, entry) ->
      formattedDate = moment(entry.date).format('MM-DD-YYYY')
      acc[formattedDate] or= ""
      acc[formattedDate] += "<span class='entry #{entry.typeSlug()}'></span>" unless acc[formattedDate].indexOf(entry.typeSlug()) >= 0
      acc

    caldata = _.reduce WodEntry.all(), reduceData, {}

    date = moment(Superfit.currentDate)
    @cal = @calendarEl.calendario
      month: date.month() + 1
      year: date.year()
      onDayClick: @dayClick
      displayWeekAbbr : true
      caldata: caldata

    @updateMonthYear()

  nextMonth: ->
    @cal.gotoNextMonth( @updateMonthYear )

  prevMonth: ->
    @cal.gotoPreviousMonth( @updateMonthYear )

  updateMonthYear: =>
    @monthEl.html( @cal.getMonthName() )
    @yearEl.html( @cal.getYear() )

  dayClick: (el, contentEl, properties) =>
    month = properties.month
    day = properties.day
    year = properties.year
    newDate = new Date(year, month - 1, day)

    if newDate.getTime() <= moment().startOf('day').valueOf()
      Superfit.trigger( 'changeDate', newDate)



