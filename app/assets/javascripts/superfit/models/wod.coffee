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

  @byName: (name) ->
    _.find @all(), (wod) -> wod.name == name

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

  typeSlug: -> @type.toLowerCase()
  strength: -> @typeSlug() == 'strength'

  repMax: (reps) ->
    max = @personal_record["max_#{reps}"]
    if max
      "#{max} lbs"
    else
      "No record"

  recordString: (summary=false) ->
    if @personal_record?
      WodEntry.scoreString(@personal_record, @scoring_method, summary)
    else
      ""

  history: ->
    history = _.map WodEntry.byWodId(@id), (entry) -> [entry.date, entry.value()]
    _.sortBy history, (history) -> history[0]

  isRecord: (entry) ->
    throw "Can't check record unless entry is for this wod" unless entry.wod_id = @id
    if @personal_record?
      switch @scoring_method
        when 'for_time'
          if entry.type == 'RX' and @personal_record.type == 'scaled'
            true
          else if entry.type == 'scaled' and @personal_record.type == 'RX'
            false
          else
            record_seconds = @personal_record.min * 60 + @personal_record.sec
            entry_seconds = entry.min * 60 + entry.sec
            entry_seconds < record_seconds
        when 'rounds', 'weight', 'max_reps' then entry.score > @personal_record.score
        when 'weight_reps'
          record = {}
          max_1 = entry.repMax(1)
          max_3 = entry.repMax(3)
          max_5 = entry.repMax(5)
          (max_1 and (!@personal_record?.max_1 or max_1 > @personal_record?.max_1)) || (max_3 and (!@personal_record?.max_3 or max_3 > @personal_record?.max_3)) || (max_5 and (!@personal_record?.max_5 or max_5 > @personal_record?.max_5))
    else
      true

  updateRecord: (entry) ->
    if entry?
      throw "Can't update record unless entry is for this wod" unless entry.wod_id = @id

      switch @scoring_method
        when 'for_time'
          record = {min: entry.min, sec: entry.sec, type: entry.type}
        when 'rounds', 'weight', 'max_reps'
          record = {score: entry.score, type: entry.type}
        when 'weight_reps'
          record = {}
          max_1 = entry.repMax(1)
          max_3 = entry.repMax(3)
          max_5 = entry.repMax(5)
          console.log "Max 1", max_1
          console.log "Max 3", max_3
          console.log "Max 5", max_5
          record.max_1 = max_1 if max_1 and (!@personal_record?.max_1 or max_1 > @personal_record.max_1)
          record.max_3 = max_3 if max_3 and (!@personal_record?.max_3 or max_3 > @personal_record.max_3)
          record.max_5 = max_5 if max_5 and (!@personal_record?.max_5 or max_5 > @personal_record.max_5)

      record = _.extend record, {entry_id: entry.id}
      if @personal_record?
        @personal_record = _.extend @personal_record, record
      else
        @personal_record = record
      console.log "Record after", @personal_record
      @save()
    else
      @updateAttributes(personal_record: null)

    @trigger('newRecord')

window.Wod = Wod
