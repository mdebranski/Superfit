class Superfit.WodItem extends Spine.Controller
  tag: 'li'
  templateName: '_wod_item'

  events:
    'tap a': 'select'

  render: -> super(wod: @wod, type: @type)

  select: =>
    if @type == 'goal'
      Goal.trigger 'new', @wod
    else if @type == 'wod'
      Wod.trigger 'new', @wod
