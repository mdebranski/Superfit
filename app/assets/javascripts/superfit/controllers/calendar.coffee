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
    @cal = @calendarEl.calendario
      onDayClick: @dayClick
      displayWeekAbbr : true

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



