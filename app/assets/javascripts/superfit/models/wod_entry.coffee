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
             'created_date',
             'date',
             'warm_up',
             'photo'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

  @byDate: (date) ->
    _.select @all(), (entry) ->
      moment(entry.date).startOf('day').valueOf() == date.getTime()

  @byWodId: (wod_id) ->
    _.select @all(), (entry) -> wod_id == entry.wod_id

  @history: (wod) ->
    _.sortBy WodEntry.byWodId(wod.id), (entry) -> -1 * entry.date

  wod: ->
    Wod.find(@wod_id)

  scoreString: (summary=false) ->
    WodEntry.scoreString(this, @method, summary)

  value: ->
    switch @method
      when 'for_time'
        @min * 60 + @sec
      when 'rounds','weight','max_reps'
        @score
      when 'weight_reps'
        _.max @weight

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
      when 'weight_reps'
        if score_obj.score
          "#{score_obj.score}lb x #{score_obj.reps} reps"
        else if score_obj.max_1
          "#{score_obj.max_1} lbs 1RM"
        else if score_obj.max_3
          "#{score_obj.max_3} lbs 3RM"
        else if score_obj.max_5
          "#{score_obj.max_5} lbs 5RM"
        else
          @weightRepsString(score_obj, summary)

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

  repMax: (reps) ->
    reduceWeights = (acc, currentReps, i) => if currentReps == reps and @weight[i] > acc then @weight[i] else acc
    _.reduce @reps, reduceWeights, null

window.WodEntry = WodEntry
