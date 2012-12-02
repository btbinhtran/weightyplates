class WPApp.Models.Exercise extends Backbone.Model

class WPApp.Collections.Exercises extends Backbone.Collection
  url: '/exercises'
  model: WPApp.Models.Exercise