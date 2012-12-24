class Weightyplates.Views.CalculatorResults extends Backbone.View

  template: JST['calculator/calculator_results']

  render: ->
    $(@el).html(@template())
    this



