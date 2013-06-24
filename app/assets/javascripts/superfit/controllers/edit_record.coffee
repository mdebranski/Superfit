class Superfit.EditRecord extends Spine.Controller

  templateName: 'edit_record'

  elements:
    'form': 'form'
    '.score-label': 'scoreLabel'

  events:
    'tap .filter-navigation a': 'navigate'

  constructor: ->
    super
    Wod.bind 'editRecord', @updateEditRecord
    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in' and id = @el.data('referrer')?.data('id')
        @wod = Wod.find(id)
        @updateEditRecord(@wod)

  render: ->
    super
    @changeMethod()
    @initSpinners()
    @initValidation()

  changeMethod: ->
    @$('.score').hide()
    @$('.score input').attr('disabled', true)
    method = @wod.scoring_method
    @$(".#{method}.score").show().attr('disabled', false)
    @$(".#{method}.score input").removeAttr('disabled')

    if @wod.typeSlug() == 'strength'
      @scoreLabel.text "Enter Your #{@repMax} Rep Max"
    else
      @scoreLabel.text 'Enter New Record'

  navigate: (e) ->
    e.preventDefault()
    repMax = $(e.target).closest('a').data('rep-max')
    Wod.trigger 'goToRecord', @wod.id, repMax

  initSpinners: ->
    @$('input[type=number]').spinner()

  initValidation: ->
    @form.validate
      submitHandler: @submit

  updateEditRecord: (wod, repMax=1) =>
    @wod = wod
    @repMax = repMax
    @render(wod: @wod, repMax: @repMax)

  submit: =>
    data = @form.serializeObject()
    @wod.personal_record or= {}
    @wod.personal_record = _.extend @wod.personal_record, data
    @wod.save()
    @wod.trigger('newRecord')
    Wod.trigger('goToRecord', @wod.id, @repMax)
