class Superfit.WodItem extends Spine.Controller
  tag: 'li'
  templateName: '_wod_item'

  events:
    'tap a': 'select'

  render: -> super(wod: @wod)

  select: =>
    Wod.trigger 'new', @wod
