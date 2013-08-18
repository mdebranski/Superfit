class Superfit.AddWod extends Superfit.SearchWods

  searchType: 'wod'

  elements:
    '.wods-search': 'wodsSearch'
    '.wods-browse': 'wodsBrowse'
    '.no-matches': 'noMatches'
    'input.search-text': 'searchEl'

  events:
    'keyup input.search-text': 'search'
    'tap input.search-text': 'search'
    'tap .wods-browse li a.custom': 'addCustomWod'
    'tap .wods-browse li a.browse': 'browseWods'

  constructor: ->
    super
    @registerStateEvents()
    @render()

  addCustomWod: -> Wod.trigger 'new', null

  browseWods: (e) ->
    type = $(e.target).closest('li').data('type')
    Wod.trigger 'browse', type
