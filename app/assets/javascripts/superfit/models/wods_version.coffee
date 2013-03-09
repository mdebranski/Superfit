class WodsVersion extends Spine.Model
  @configure 'WodsVersion',
             'version'

  @extend Spine.Model.Local

  needs_update: (latest_version) -> !@version || @version < latest_version

window.WodsVersion = WodsVersion
