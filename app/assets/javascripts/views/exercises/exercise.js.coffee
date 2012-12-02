class WPApp.Views.Exercise extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: 'exercises/exercise'
  events:
    'click .destroy': 'destroy'

  destroy: ->
    @model.destroy() if confirm 'Are you sure?'

class WPApp.Views.Entries extends Backbone.Marionette.CompositeView
  tagName: 'ul'
  itemView: WPApp.Views.Exercise
  template: 'exercises/index'
  events:
    'click .new-exercise': 'newExercise'
  appendHtml: (collectionView, itemView) ->
    collectionView.$('.exercises').append(itemView.el)
  newExercise: ->
    name = prompt('Enter name:')
    @collection.create name: name if name


