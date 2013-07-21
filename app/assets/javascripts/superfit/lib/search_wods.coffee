class Superfit.SearchWods extends Spine.Controller

  constructor: ->
    super

    @el.bind "pageAnimationEnd", (e, data) =>
      if data.direction == 'out'
        @searchEl.val('')
        @clearSearch()

  search: (e, type=null) ->
    value = $(e.target).val()

    if value? and value.length > 0
      @log "Searching for #{value} of type #{type or 'all'}"

      @wodsBrowse.hide()

      @wodsSearch.html('')
      wods = Wod.search(value, type)
      if wods.length > 0
        for wod in wods
          item = new Superfit.WodItem(wod: wod, type: @searchType)
          @wodsSearch.append item.render()
        @noMatches.hide()
        @wodsSearch.fadeIn()
      else
        @noMatches.fadeIn()

    else
      @clearSearch()

  clearSearch: ->
    @wodsSearch.hide()
    @noMatches.hide()
    @wodsBrowse.fadeIn()
