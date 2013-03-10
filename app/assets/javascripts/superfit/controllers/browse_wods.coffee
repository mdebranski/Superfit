class Superfit.BrowseWods extends Superfit.SearchWods

  elements:
    '.wods-search': 'wodsSearch'
    '.wods-browse': 'wodsBrowse'
    '.no-matches': 'noMatches'
    '.page-header h1': 'header'

  events:
    'keyup input.search-text': 'search'
    'tap input.search-text': 'search'

  constructor: ->
    super
    Wod.bind 'browse', @updateWods

  updateWods: (type) =>
    @type = type
    @header.text("#{@type.toUpperCase()}")

    wods = Wod.byType(type)
    @wodsBrowse.html('')
    for wod in wods
      item = new Superfit.WodItem(wod: wod)
      @wodsBrowse.append item.render()

  search: (e) -> super(e, @type)
