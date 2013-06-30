class Superfit.EditProfileGym extends Spine.Controller

  elements:
    '.gyms': 'gymsEl'
    '.no-matches': 'noMatches'
    'input[name=gym_id]': 'gymId'
    'form': 'form'

  events:
    'tap .gym': 'selectGym'
    'keydown input#gym-search': 'search'



  constructor: ->
    super
    @render(user: User.first())
    @debounceLoadGyms = _.debounce( @loadGyms, 300 )
    @form.validate
      submitHandler: @submit

  submit: =>
    data = @form.serializeObject()

    @log "Form data", data

    if data.gym_id
      data.gym = _.find @gyms, (gym) -> gym.id.toString() == data.gym_id

    user = User.first()
    user.updateAttributes(data)
    jQT.goTo('#edit-profile', jQT.settings.defaultTransition)

  search: (e) ->
    e.preventDefault() if e.keyCode == 13
    value = $(e.target).val()
    if value? and value.length > 0
      @debounceLoadGyms(value)
    else
      @gymsEl.hide()

  loadGyms: (search) ->
    $.getJSON "/api/gyms?name=#{search}", @addGyms

  addGyms: (@gyms) =>
    @gymsEl.html('')

    if @gyms and @gyms.length > 0
      _.each @gyms, (gym) =>
        @gymsEl.append JST['superfit/views/_gym'](gym: gym)
      @noMatches.hide()
      @gymsEl.fadeIn()
    else
      @gymsEl.hide()
      @noMatches.fadeIn()

  selectGym: (e) =>
    li = $(e.target).closest('li')
    gym_id = li.data('id')
    @gymId.val(gym_id)
    @$('.gym').removeClass('selected')
    li.addClass('selected')

