class User extends Spine.Model
  @configure 'User',
             'id',
             'name'

  @extend Spine.Model.Ajax
  @extend Spine.Events
  @extend Spine.Log

window.User = User
