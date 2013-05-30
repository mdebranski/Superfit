class Superfit.Calendar extends Spine.Controller

  elements:
    '.fc-calendar-container': 'calendarEl'
    '#custom-month': 'monthEl'
    '#custom-year': 'yearEl'

  events:
    'click #custom-next': 'nextMonth'
    'click #custom-prev': 'prevMonth'

  constructor: ->
    super
    @render()

    reduceData = (acc, entry) ->
      formattedDate = moment(entry.date).format('MM-DD-YYYY')
      acc[formattedDate] or= ""
      acc[formattedDate] += "<span class='entry #{entry.typeSlug()}'></span>"
      acc

    caldata = _.reduce WodEntry.all(), reduceData, {}

    @cal = @calendarEl.calendario
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



