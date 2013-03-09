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

  @byType: (type) ->
    _.select @all(), (wod) ->
      wod.type.toLowerCase() == type.toLowerCase()

  @byCategory: (category) ->
    _.select @all(), (wod) ->
      wod.category.toLowerCase() == category.toLowerCase()

  @search: (value, type = null) ->
    wods = if type? then Wod.byType(type) else Wod.all()
    _.select wods, (wod) ->
      wod.name.toLowerCase().indexOf(value.toLowerCase()) >= 0

  typeSlug: ->
    @type.toLowerCase()

window.Wod = Wod
