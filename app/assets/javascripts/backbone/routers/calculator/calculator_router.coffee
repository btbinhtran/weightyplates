class Weightyplates.Routers.Calculator extends Backbone.Router
  routes:
    '': 'calculatorIndex'

  calculatorIndex: ->
    viewCalculator = new Weightyplates.Views.CalculatorIndex()

    $('.hero-unit').html(viewCalculator.render().el)
