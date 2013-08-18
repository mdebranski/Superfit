class Superfit.EditWod extends Spine.Controller

  elements:
    'form': 'form'
    '.sets': 'sets'
    '.customwod-tabs': 'tabs'
    '.custom-wod-photo': 'customWodPhoto'
    '.custom-wod-img': 'customWodImage'
    '.initial-capture': 'initialCapture'
    '.post-capture': 'postCapture'

  events:
    'tap .add-set': 'addSet'
    'tap .remove-set': 'removeSet'
    'change select[name=method]': 'changeMethod'
    'change input[type=number]' : 'notNegative'
    'spinstop input[type=number]' : 'notNegative'
    'tap .take-photo': 'takePhoto'
    'tap .warm-up': 'togglestyle'
    'tap .tab-nav .tab-btn': 'togglePhoto'
    'tap .delete-photo': 'deletePhoto'

  constructor: ->
    super
    @registerStateEvents()

    Wod.bind 'new', @updateNewWod

    @el.bind "pageAnimationStart", (e, data) =>
      if data.direction == 'in' and id = @el.data('referrer')?.data('id')
        entry = WodEntry.find(id)
        @updateEditEntry(entry)

  takePhoto: (e) ->
    return  unless window.device.platform

    # a little bit of nested-callback hell.  Sorry about this, I didn't see any flow-control libs.
    captureSuccess = (filePath) =>

      # get pointer to image
      window.resolveLocalFileSystemURI filePath, ((file) =>

        # guarantee a unique filename
        filename = Date.now() + ".jpg"

        # get pointer to persistent storage
        window.requestFileSystem LocalFileSystem.PERSISTENT, 0, ((fs) =>

          # copy the image to persistent storage
          file.copyTo fs.root, filename, ((newFile) =>
            @customWodPhoto.val newFile.fullPath
            @customWodImage.attr "src", newFile.fullPath
            @updatePhoto(newFile.fullPath)
          ), captureError
        ), captureError
      ), captureError

    captureError = (error) ->
      self.log error
      unless error is "no image selected"

        # have to use a timer because of a weird phonegap-ios quirk
        setTimeout (->
          navigator.notification.alert "An error occurred with your photo.  Please try again."
        ), 0

    options =
      quality: 75
      destinationType: Camera.DestinationType.FILE_URI
      sourceType: Camera.PictureSourceType.CAMERA
      #sourceType: Camera.PictureSourceType.SAVEDPHOTOALBUM
      #allowEdit: true
      encodingType: Camera.EncodingType.JPEG
      targetWidth: 320
      targetHeight: 480
      saveToPhotoAlbum: false

    # prompt user to take a picture or choose from their library
    navigator.camera.getPicture captureSuccess, captureError, options
    e.preventDefault()


  changeMethod: ->
    @$('.score').hide()
    @$('.score input').attr('disabled', true)
    method = if @wod then @wod.scoring_method else @$('select[name=method]').val()
    @$(".#{method}.score").show().attr('disabled', false)
    @$(".#{method}.score input").removeAttr('disabled')

  render: ->
    super
    @initSpinners()
    @initValidation()
    @changeMethod()

  initSpinners: ->
    @$('input[type=number]').spinner()

  initValidation: ->
    @form.validate
      errorPlacement: (error, element) ->
        error.appendTo( element.closest('.ui-spinner') )
      highlight: (element) ->
        $(element).removeClass('success').addClass('form-error')
        $(element).closest('.enter-score').removeClass('success').addClass('error');
      unhighlight: (element) ->
        $(element).removeClass('form-error').addClass('success')
        $(element).closest('.enter-score').removeClass('error').addClass('success');

      submitHandler: @submit

  deletePhoto: (e) ->
    e.preventDefault()
    @customWodPhoto.val ''
    @customWodImage.attr "src", ''
    @updatePhoto('')

  updatePhoto: (photo) ->
    if photo
      @initialCapture.hide()
      @postCapture.show()
    else
      @postCapture.hide()
      @initialCapture.show()

  updateNewWod: (wod) =>
    @wod = wod
    @templateName = if wod and wod.type == 'Strength' then 'enter_strength_score' else 'enter_wod_score'
    @render(wod: @wod, user: User.first())
    @addSets() if @wod and @wod.type == 'Strength'
    @updatePhoto(null)

  updateEditEntry: (entry) ->
    @wod = Wod.find(entry.wod_id) if entry.wod_id
    @templateName = if @wod and @wod.type == 'Strength' then 'enter_strength_score' else 'enter_wod_score'
    @render(wod: @wod, entry: entry, user: User.first())
    @addSets(entry) if @wod and @wod.type == 'Strength'
    @updatePhoto(entry.photo)

  toInt: (numOrArray) ->
    return null unless numOrArray
    if typeof(numOrArray) == 'object'
      _.map numOrArray, (num) -> parseInt(num)
    else
      parseInt(numOrArray)

  ensureArray: (arrayOrNot) ->
    if typeof(arrayOrNot) == 'object'
      arrayOrNot
    else
      [arrayOrNot]

  submit: =>
    data = @form.serializeObject()

    method = if @wod then @wod.scoring_method else data.method
    attributes =
       wod_id: @wod and @wod.id
       name: data.name
       score: if method == 'pass_fail' then data.score else @toInt(data.score)
       min: @toInt(data.min)
       sec: @toInt(data.sec)
       reps: @ensureArray @toInt(data.reps)
       weight: @ensureArray @toInt(data.weight)
       method: method
       type: data.type
       details: data.details
       created_date: new Date().valueOf()
       date: new Date(Superfit.currentDate).valueOf()
       warm_up: data.warm_up
       photo: data.photo


    if data.entry_id
      entry = WodEntry.find(data.entry_id)
      entry.updateAttributes(attributes)
    else
      entry = WodEntry.create(attributes)

    jQT.goTo('#review-wod', jQT.settings.defaultTransition)

  addSets: (entry=null) ->
    unless entry
      @addSet()
    else
      _.each entry.reps, (reps, i) => @addSet(null, reps, entry.weight[i])

  togglestyle: (e)->
   $(e.target).toggleClass "selected", $(e.target).is(":checked")

  togglePhoto: (e)->
    if @tabs.hasClass('photo')
      @tabs.removeClass('photo').addClass('text')
    else if @tabs.hasClass('text')
      @tabs.removeClass('text').addClass('photo')


  addSet: (e=null, reps=null, weight=null) ->
    e.preventDefault() if e
    @set_number = @$('.set').length + 1

    html = JST['superfit/views/_set'](set_number: @set_number, reps: reps, weight: weight)
    @sets.append(html)
    @initSpinners()

  removeSet: (e) ->
    e.preventDefault()

    if $('.set').length > 1
      $(e.target).closest('.set').detach()
    else
      $('input[type=number]').val('')

    _.each $('.set-number'), (el, i) -> $(el).text(i+1)

  notNegative: (e) ->
    val = $(e.target).val()
    if parseInt(val) < 0
      $(e.target).val(0)
