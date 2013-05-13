class WodEntry extends Spine.Model
  @configure 'WodEntry',
             'id',
             'wod_id',
             'score',
             'min',
             'sec',
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

  scoreString: ->
    switch @method
      when 'for_time' then "#{@min} minutes #{@sec} seconds"
      when 'rounds' then "#{@score} rounds"
      when 'weight' then "#{@score} lbs"
      when 'max_reps' then "#{@score} reps"
      when 'pass_fail' then @score.toUpperCase()

window.WodEntry = WodEntry
