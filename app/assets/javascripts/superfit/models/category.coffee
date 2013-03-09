class Category extends Spine.Model
  @configure 'Category',
             'name'

  @extend Spine.Model.Local
  @extend Spine.Events
  @extend Spine.Log

window.Category = Category
