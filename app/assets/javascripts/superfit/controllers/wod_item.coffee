class Superfit.WodItem extends Spine.Controller
  templateName: '_wod_item'

  events:
    'tap a': 'select'

  render: -> super(wod: @wod)

  select: =>
    Wod.trigger 'new', @wod

  selectWod: (e) ->
    id = $(e.target).closest('li').data('id')
    wod = Wod.find(id)
    workout = wod.workout_male.replace(/\n/g, '<br/>')

    @$('.wod-name', @step2).html("<span class='icon sprite-sf #{wod.type.toLowerCase()}'></span>#{wod.name}")
    @$('.wod-details p', @step2).html(workout)
    jQT.goTo('#new-wod', jQT.settings.defaultAnimation)
