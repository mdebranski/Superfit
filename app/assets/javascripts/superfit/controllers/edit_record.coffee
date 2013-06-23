class Superfit.EditRecord extends Spine.Controller

  templateName: 'edit_record'

  elements:
    'form': 'form'

  constructor: ->
    super
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

  initSpinners: ->
    @$('input[type=number]').spinner()

  initValidation: ->
    @form.validate
      submitHandler: @submit

  updateEditRecord: (wod) ->
    @wod = wod
    @render(wod: @wod)

  submit: =>
    data = @form.serializeObject()
    @wod.updateAttributes(personal_record: data)
    @wod.trigger('newRecord')
    jQT.goTo('#record-detail', jQT.settings.defaultTransition)
