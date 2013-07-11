class Superfit.WodItem extends Spine.Controller
  tag: 'li'
  templateName: '_wod_item'

  events:
    'tap a': 'select'

  constructor: ->
    super
    throw "No wod specified" unless @wod
    throw "No wod type specified" unless @type

  render: -> super(wod: @wod, type: @type)

  select: =>
    if @type == 'goal'
      Goal.trigger 'new', @wod
    else if @type == 'wod'
      Wod.trigger 'new', @wod
    else
      throw "Unrecognized wod item type: #{@type}"
