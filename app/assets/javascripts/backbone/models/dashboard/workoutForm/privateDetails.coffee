class Weightyplates.Models.PrivateDetails extends Backbone.Model

  defaults:
    utilityFunction: null
    weightInputError: false
    repInputError: false
    notifyFromButton: null
    lastIsValidStateWeight: null
    prevIsValidStateWeight: true
    currentIsValidStateWeight: null
    lastIsValidStateRep: null
    prevIsValidStateRep: true
    currentIsValidStateRep: null
    triggerFromExercise: null
    signalFromParent: -1
    needingHighlighting: false

