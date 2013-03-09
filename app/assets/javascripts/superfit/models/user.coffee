class User extends Spine.Model
  @configure 'User',
             'id',
             'name'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

window.User = User
