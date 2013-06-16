class WodEntry extends Spine.Model
  @configure 'WodEntry',
             'id',
             'wod_id',
             'name',
             'score',
             'min',
             'sec',
             'reps',
             'weight'
             'method',
             'type',
             'details',
             'date',

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

  @byDate: (date) ->
    _.select @all(), (entry) ->
      moment(entry.date).startOf('day').valueOf() == date.getTime()

  @byWodId: (wod_id) ->
    _.select @all(), (entry) -> wod_id == entry.wod_id

  wod: ->
    Wod.find(@wod_id)

  scoreString: ->
    switch @method
      when 'for_time' then _.str.sprintf "%d:%02d", Number(@min), Number(@sec)
      when 'rounds' then "#{@score} rounds"
      when 'weight' then "#{@score} lbs"
      when 'max_reps' then "#{@score} reps"
      when 'pass_fail' then @score.toUpperCase()
      when 'weight_reps' then @weightRepsString()

  weightRepsString: ->
    return "" unless @reps and @reps.length > 0
    func = (acc, reps, i) => acc + "#{@weight[i]}lb x #{reps} reps, "
    str = _.reduce @reps, func, ""
    str[0..str.length - 3]

  typeSlug: -> if @wod_id then @wod().typeSlug() else "custom"

  wodName: -> if @wod_id then @wod().name else @name

window.WodEntry = WodEntry
