class Goal extends Spine.Model
  @configure 'Goal',
             'id',
             'start_date',
             'complete_date',
             'last_update',
             'start_entry_id',
             'last_entry_id',
             'history',

             'wod_id',
             'score',
             'min',
             'sec',
             'reps',
             'type'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

  name: ->
    wod = Wod.find(@wod_id)
    "#{wod.name} #{@scoreString()}"

  percentComplete: ->
    if @last_entry_id
      Math.floor(_.min [(@progress() / @total() * 100), 100])
    else
      0
  wod: -> Wod.find(@wod_id)
  start_entry: -> WodEntry.find(@start_entry_id) if @start_entry_id
  last_entry:  -> WodEntry.find(@last_entry_id)  if @last_entry_id

  scoreString: (summary=false) ->
    WodEntry.scoreString(this, @wod().scoring_method, summary)

  start_score: ->
    if @start_entry_id
      Goal.score(@start_entry())
    else
      0

  last_score: ->
    if @last_entry_id
      Goal.score(@last_entry())
    else
      0

  progress: ->
    if @wod().scoring_method == 'for_time'
      @start_score() - @last_score()
    else
      @last_score() - @start_score()

  total: ->
    if @wod().scoring_method == 'for_time'
      @start_score() - @goal_score()
    else
      @goal_score() - @start_score()

  goal_score: ->
    Goal.score(this)

  newEntry: (entry) =>
    if @isMatch(entry)
      @start_entry_id = entry.id unless @start_entry_id
      @last_entry_id = entry.id

      @history or= []
      @history.push [moment().valueOf(), @percentComplete()]

      if @isComplete() and !@complete_date
        @complete_date = moment().valueOf()

      @save()
    else
      console.log "NOT A MATCH", entry

  isMatch: (entry) ->
    throw "Can't check goal match unless entry is for this wod" unless entry.wod_id == @wod_id
    switch @wod().scoring_method
      when 'rounds', 'weight', 'max_reps' then true
      when 'for_time' then entry.type == @type
      when 'weight_reps' then _.find entry.reps, (reps) => reps == @reps

  isComplete: ->
    if @wod().scoring_method == 'for_time'
      @last_score() <= @goal_score()
    else
      @last_score() >= @goal_score()

  @byWodId: (wodId) ->
    _.filter Goal.all(), (goal) -> goal.wod_id == wodId

  @inProgress: ->
    _.filter Goal.all(), (goal) -> !goal.complete_date?

  @completed: ->
    _.filter Goal.all(), (goal) -> goal.complete_date?

  @score: (model) ->
    wod = model.wod()

    switch wod.scoring_method
      when 'for_time' then (model.min * 60) + model.sec
      when 'rounds', 'weight', 'max_reps', 'weight_reps' then model.score
      when 'pass_fail'
        if model.score.toUpperCase() == 'PASS' then 1 else 0

window.Goal = Goal
