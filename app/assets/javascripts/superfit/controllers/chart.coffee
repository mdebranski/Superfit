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
      xaxis:
        mode: 'time'
      yaxis:
        max: 100
        tickFormatter: (value) -> "#{value}%"
    @chart(el, data, options)

  @defaultOptions:
    options =
      xaxis:
        labelWidth: 40
      yaxis:
        min: 0
        minTickSize: 1
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
