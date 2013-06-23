class Superfit.Records extends Spine.Controller

  events:
    'tap .filter-navigation a': 'navigateType'

  currentType: 'strength'

  constructor: ->
    super
    @render()

    Wod.bind 'newRecord', => @render()
    WodEntry.bind 'create update', (entry) => @checkIfNewRecord(entry)
    WodEntry.bind 'destroy', (entry) => @entryDestroyed(entry)

  render: ->
    @log "Rendering records"
    super
    @updateTypes()

  navigateType: (e) ->
    e.preventDefault()
    @currentType = $(e.target).data('type')
    @updateTypes()

  updateTypes: ->
    @$("section:visible").hide()
    @$("section.#{@currentType}").fadeIn()

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
    isRecord = (acc, entry) -> if wod.isRecord(entry) then entry else acc
    record = _.reduce WodEntry.history(wod), isRecord, null
    wod.updateRecord(record)
