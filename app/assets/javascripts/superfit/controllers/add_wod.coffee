class Superfit.AddWod extends Superfit.SearchWods

  elements:
    '.wods-search': 'wodsSearch'
    '.wods-browse': 'wodsBrowse'
    '.no-matches': 'noMatches'
    'input.search-text': 'searchEl'

  events:
    'keyup input.search-text': 'search'
    'tap input.search-text': 'search'
    'tap .wods-browse li a': 'browseWods'

  browseWods: (e) ->
    type = $(e.target).closest('li').data('type')
    Wod.trigger 'browse', type
