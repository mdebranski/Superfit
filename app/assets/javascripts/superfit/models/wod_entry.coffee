class WodEntry extends Spine.Model
  @configure 'WodEntry',
             'id',
             'wod_id',
             'score',
             'method',
             'type',
             'details',
             'date'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

  @byDate: (date) ->
    _.select @all(), (entry) ->
      moment(entry.date).startOf('day').valueOf() == date.getTime()

  wod: ->
    Wod.find(@wod_id)

  units: ->
    switch @method
      when 'time' then 'seconds'
      when 'rounds' then 'rounds'
      when 'weight' then 'lbs'
      when 'reps' then 'reps'
      when 'passfail' then ''

  scoreString: ->
    "#{@score} #{@units()}"

window.WodEntry = WodEntry
