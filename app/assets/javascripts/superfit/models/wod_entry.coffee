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

  @history: (wod) ->
    _.sortBy WodEntry.byWodId(wod.id), (entry) -> -1 * moment(entry.date).valueOf()

  wod: ->
    Wod.find(@wod_id)

  scoreString: (summary=false) ->
    WodEntry.scoreString(this, @method, summary)

  @scoreString: (score_obj, method, summary=false) ->
    switch method
      when 'for_time'
        if summary
          _.str.sprintf "%d:%02d %s", Number(score_obj.min), Number(score_obj.sec), score_obj.type
        else
          _.str.sprintf "%d:%02d", Number(score_obj.min), Number(score_obj.sec)
      when 'rounds' then "#{score_obj.score} rounds"
      when 'weight' then "#{score_obj.score} lbs"
      when 'max_reps' then "#{score_obj.score} reps"
      when 'pass_fail' then score_obj.score.toUpperCase()
      when 'weight_reps' then @weightRepsString(score_obj, summary)

  @weightRepsString: (score_obj, summary) ->
    return "" unless score_obj.reps and score_obj.reps.length > 0
    if summary
      last_idx = score_obj.reps.length - 1
      "#{score_obj.weight[last_idx]}lb x #{score_obj.reps[last_idx]} reps"
    else
      func = (acc, reps, i) => acc + "#{score_obj.weight[i]}lb x #{reps} reps, "
      str = _.reduce score_obj.reps, func, ""
      str[0..str.length - 3]

  typeSlug: -> if @wod_id then @wod().typeSlug() else "custom"

  wodName: -> if @wod_id then @wod().name else @name

window.WodEntry = WodEntry
