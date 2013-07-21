class Goal extends Spine.Model
  @configure 'Goal',
             'id',
             'start_date',
             'complete_date',
             'last_update',
             'start_entry_id',
             'start_score',
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
    if @total() == 0
      100
    else if @last_entry_id
      percent = Math.floor(@progress() / @total() * 100)
      if percent > 100
        100
      else if percent < 0
        0
      else
        percent
    else
      0

  wod: -> Wod.find(@wod_id)
  start_entry: -> WodEntry.find(@start_entry_id) if @start_entry_id
  last_entry:  -> WodEntry.find(@last_entry_id)  if @last_entry_id

  scoreString: (summary=false) ->
    WodEntry.scoreString(this, @wod().scoring_method, summary)

  best_score: ->
    if @last_entry_id
      if @wod().scoring_method == 'for_time'
        best_entry = _.min @entries(), (entry) => @calcScore(entry)
      else
        best_entry = _.max @entries(), (entry) => @calcScore(entry)

      if best_entry
        @calcScore(best_entry)
      else
        0
    else
      0

  progress: ->
    if @wod().scoring_method == 'for_time'
      @start_score - @best_score()
    else
      @best_score() - @start_score

  total: ->
    if @wod().scoring_method == 'for_time'
      @start_score - @goal_score()
    else
      @goal_score() - @start_score

  goal_score: ->
    @calcScore(this)

  entries: ->
    entries = _.select WodEntry.byWodId(@wod_id), (entry) =>
      @start_entry_id == entry.id || (@isMatch(entry) && entry.created_date >= @start_date and (!@complete_date or entry.date < @complete_date))
    _.sortBy entries, (entry) -> -1 * moment(entry.created_date).valueOf()

  newEntry: (entry, start=false) =>
    if @isMatch(entry)
      if start
        @start_entry_id = entry.id
        @start_score = @calcScore(entry)

      @last_entry_id = entry.id

      @history or= []
      @history.push [moment().valueOf(), @percentComplete()]

      if @isComplete() and !@complete_date
        @trigger('complete')
        @complete_date = moment().valueOf()

      @save()
    else
      console.log "NOT A MATCH", entry

  isMatch: (entry) ->
    throw "Can't check goal match unless entry is for this wod" unless entry.wod_id == @wod_id
    switch @wod().scoring_method
      when 'rounds', 'weight', 'max_reps' then true
      when 'for_time' then entry.type.toLowerCase() == @type.toLowerCase()
      when 'weight_reps' then _.find entry.reps, (reps) => reps == @reps

  isComplete: ->
    if @wod().scoring_method == 'for_time'
      @best_score() <= @goal_score()
    else
      @best_score() >= @goal_score()

  calcScore: (model) ->
    wod = model.wod()

    switch wod.scoring_method
      when 'for_time' then (model.min * 60) + model.sec
      when 'rounds', 'weight', 'max_reps' then model.score
      when 'weight_reps'
        if model.repMax?
          model.repMax(@reps)
        else
          model.score
      when 'pass_fail'
        if model.score.toUpperCase() == 'PASS' then 1 else 0

  @byWodId: (wodId) ->
    _.filter Goal.all(), (goal) -> goal.wod_id == wodId

  @lastUpdated: ->
    _.max Goal.inProgress(), (goal) -> goal.last_update

  @inProgress: ->
    _.filter Goal.all(), (goal) -> !goal.complete_date?

  @completed: ->
    _.filter Goal.all(), (goal) -> goal.complete_date?

window.Goal = Goal
