class Wod extends Spine.Model
  @configure 'Wod',
             'id',
             'name',
             'type',
             'category',
             'scoring_method',
             'workout_male',
             'workout_female',
             'scoring_notes',
             'workout_notes',
             'personal_record'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

  @scoringMethodMap: {for_time: "For Time", pass_fail: "Pass/Fail", rounds: "AMRAP (rounds)", max_reps: "Max Reps", weight_reps: "Weight / Reps / Rounds"}

  @byType: (type) ->
    wods = _.select @all(), (wod) ->
      wod.typeSlug() == type.toLowerCase()
    _.sortBy wods, (wod) -> wod.name.toLowerCase()

  @byCategory: (category) ->
    _.select @all(), (wod) ->
      wod.category.toLowerCase() == category.toLowerCase()

  @search: (value, type = null) ->
    wods = if type? then Wod.byType(type) else Wod.all()
    _.select wods, (wod) ->
      wod.name.toLowerCase().indexOf(value.toLowerCase()) >= 0

  scoringMethod: ->
    Wod.scoringMethodMap[@scoring_method]

  typeSlug: ->
    @type.toLowerCase()

  recordString: (summary=false) ->
    if @personal_record?
      WodEntry.scoreString(@personal_record, @scoring_method, summary)
    else
      ""

  isRecord: (entry) ->
    throw "Can't check record unless entry is for this wod" unless entry.wod_id = @id
    if @personal_record?
      switch @scoring_method
        when 'for_time'
          if entry.type == 'rx' and @personal_record.type == 'scaled'
            true
          else if entry.type == 'scaled' and @personal_record.type == 'rx'
            false
          else
            record_seconds = @personal_record.min * 60 + @personal_record.sec
            entry_seconds = entry.min * 60 + entry.sec
            entry_seconds < record_seconds
        when 'rounds', 'weight', 'max_reps' then entry.score > @personal_record.score
        when 'weight_reps' then throw "Strength not supported yet"
    else
      true

  updateRecord: (entry) ->
    if entry?
      throw "Can't update record unless entry is for this wod" unless entry.wod_id = @id
      record =
        switch @scoring_method
          when 'for_time' then {min: entry.min, sec: entry.sec, type: entry.type}
          when 'rounds', 'weight', 'max_reps' then {score: entry.score, type: entry.type}
          when 'weight_reps' then throw "Strength not supported yet"

      @personal_record = _.extend record, {entry_id: entry.id}
      @save()
    else
      @updateAttributes(personal_record: null)

    @trigger('newRecord')

window.Wod = Wod
