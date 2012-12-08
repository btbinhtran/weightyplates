class Weightyplates.Models.Dashboard extends Backbone.Model

  urlRoot : '/dashboard'

  defaults:
    dancers: [
      {gender:'male', name:'Fred'}
      {gender:'female', name: 'Jane'}
      {gender:'male', name: 'Bart'}
    ]

