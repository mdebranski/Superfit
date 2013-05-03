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
             'workout_notes'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

  @scoringMethodMap: {for_time: "For Time", pass_fail: "Pass/Fail", rounds: "AMRAP (rounds)", 'max_reps': "Max Reps"}

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

window.Wod = Wod
