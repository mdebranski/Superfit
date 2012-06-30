class Category extends Spine.Model
  @configure 'Category',
             'name'

  @extend Spine.Model.Ajax
  @extend Spine.Events
  @extend Spine.Log

window.Category = Category