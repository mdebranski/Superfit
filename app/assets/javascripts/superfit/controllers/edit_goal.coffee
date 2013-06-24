class Superfit.EditGoal extends Spine.Controller

  templateName: 'edit_goal'

  elements:
    'form': 'form'


  constructor: ->
    super
    @render()

  render: ->
    super
    @initSpinners()

  initSpinners: ->
    @$('input[type=number]').spinner()