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

  @extend Spine.Model.Ajax
  @extend Spine.Events
  @extend Spine.Log

  @byType: (type) ->
    _.select @all(), (wod) ->
      wod.type.toLowerCase() == type.toLowerCase()

  @byCategory: (category) ->
    _.select @all(), (wod) ->
      wod.category.toLowerCase() == category.toLowerCase()

window.Wod = Wod
