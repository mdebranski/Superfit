class SavedState extends Spine.Model
  @configure 'SavedState',
             'controller',
             'state'

  @extend Spine.Model.Local
  @extend Spine.Events

window.SavedState = SavedState
