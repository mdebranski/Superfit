class Superfit.Chart extends Spine.Module

  @extend Spine.Log

  @chart: (el, data, options) ->
    combinedOptions = $.extend true, {}, @defaultOptions, options
    @log "Initing chart", combinedOptions
    if data
      $.plot el, [data], combinedOptions
    else
      el.hide()

  @goalChart: (el, data) ->
    options =
      yaxis:
        max: 100
        tickSize: 25
        tickFormatter: (value) -> "#{value}%"
    @chart(el, data, options)

  @wodChart: (el, data, method) ->
    options =
      yaxis:
        tickFormatter: (value) => @formatWodValue(value, method)
    @chart(el, data, options)

  @formatWodValue: (value, method) ->
    switch method
      when 'for_time'
        min = Math.floor(value / 60)
        sec = value % 60
        _.str.sprintf "%d:%02d", Number(min), Number(sec)
      when 'rounds','weight','max_reps'
        value
      when 'weight_reps'
        "#{value} lb"

  @defaultOptions:
    options =
      xaxis:
        mode: 'time'
        labelWidth: 40
        tickFormatter: (value) -> moment(value).format('MMM D')
        ticks: 4
      yaxis:
        min: 0
        minTickSize: 1
        ticks: 4
        labelWidth:15
        align: 'center'
      series:
        color: 'rgba(78, 163, 227, 0.95)'
        lines:
          show: true
          lineWidth: 1
          fill: true
          fillColor: 'rgba(78, 163, 227, 0.15)'
          align: 'center'
        points:
          show: true
          borderWidth: 1
        shadowSize:0
      grid:
        borderWidth:1
        borderColor: 'rgba(0, 0, 0, 0.1)'
        clickable: true
        color:  'rgba(0, 0, 0, 0.2)'
        labelMargin:20

