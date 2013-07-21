class Superfit.Records extends Spine.Controller

  events:
    'tap .filter-navigation a': 'navigateType'
    'tap .records a': 'recordClicked'

  currentType: 'strength'

  constructor: ->
    super
    @render()

    Wod.bind 'newRecord', => @render()
    Wod.bind 'goToRecord', @goToRecord
    WodEntry.bind 'create update', (entry) => @checkIfNewRecord(entry)
    WodEntry.bind 'destroy', (entry) => @entryDestroyed(entry)

  render: ->
    super
    @updateTypes()

  navigateType: (e) ->
    e.preventDefault()
    @currentType = $(e.target).data('type')
    @updateTypes()

  updateTypes: ->
    @$("section:visible").hide()
    @$("section.#{@currentType}").fadeIn()
    @$(".filter-navigation a").removeClass('selected')
    @$(".filter-navigation a[data-type=#{@currentType}]").addClass('selected')

  checkIfNewRecord: (entry) ->
    if entry.wod_id?
      wod = Wod.find(entry.wod_id)
      if wod.isRecord(entry)
        wod.updateRecord(entry)

  entryDestroyed: (entry) ->
    if entry.wod_id?
      wod = Wod.find(entry.wod_id)
      if wod.personal_record?
        if wod.personal_record.entry_id == entry.id
          @findNewRecord(wod)

  findNewRecord: (wod) ->
    wod.personal_record = null
    _.each WodEntry.history(wod), (entry) -> wod.updateRecord(entry)

  recordClicked: (e) ->
    e.preventDefault()
    wod_id = $(e.target).closest('a').data('id')
    Wod.trigger('goToRecord', wod_id, 1, 'slideleft')

  goToRecord: (wod_id, repMax=1, transition='fade') ->
    wod = Wod.find(wod_id)
    hasRecord = if wod.strength() then wod.personal_record?["max_#{repMax}"]? else wod.personal_record?

    if hasRecord
      Wod.trigger 'recordDetail', wod, repMax
      jQT.goTo('#record-detail', transition)
    else
      Wod.trigger 'editRecord', wod, repMax
      jQT.goTo('#edit-record', transition)
