if Spine?
  Spine.Controller.include
    className: ->
      @.__proto__.constructor.name

    defaultTemplateName: ->
      @className().toLowerCase()

    view: (name) ->
      viewPath = "superfit/views/#{name}"
      view = JST[viewPath]
      throw "View #{viewPath} not found" unless view
      view

    template: (data) ->
      @templateName = @defaultTemplateName() unless @templateName
      @view(@templateName)(data)

    render: (data) ->
      html = @html @template(data)
      _.defer(@afterRender) if @afterRender?
      html

    # Override the default activate method in manager.coffee
    activate: ->
      @el.addClass('active')
      FB?.Canvas.scrollTo(0,0) if Buzz.fbInited
      window.scrollTo(0,0)
      @

    keyboard_shortcuts: (shortcuts) ->
      for key, callback of shortcuts
        do(key, callback) ->
          $(document).bind 'keydown', key, (e) ->
            e.preventDefault()
            callback(e)
