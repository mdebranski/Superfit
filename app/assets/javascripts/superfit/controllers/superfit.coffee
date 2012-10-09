class Superfit extends Spine.Controller
  templateName: 'superfit'

  events:
    'keyup input#search': 'search'

  constructor: ->
    super
    @render()

  search: (e) ->
    value = $(e.target).val()

    if value? and value.length > 0
      _.each $('#wodlist li'), (el) ->
        el = $(el)
        if el.text().indexOf(value) == -1
          el.hide()
        else
          el.show()
    else
      $('#wodlist li').show()

window.Superfit = Superfit
