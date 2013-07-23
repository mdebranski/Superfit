class User extends Spine.Model
  @configure 'User',
             'id',
             'name',
             'gender',
             'gym_id',
             'gym' ,
             'zipcode',
             'birthdate',
             'email',
             'newsletter'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

window.User = User
