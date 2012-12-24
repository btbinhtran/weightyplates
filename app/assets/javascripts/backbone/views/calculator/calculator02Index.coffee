class Weightyplates.Views.CalculatorIndex extends Backbone.View

  template: JST['calculator/calculator_index']

  events: ->
    'click #calculator-calculate-button': 'calculateResults'

  render: ->
    $(@el).html(@template())
    this

  calculateResults: ->
    viewCalculateResults = new Weightyplates.Views.CalculatorResults()