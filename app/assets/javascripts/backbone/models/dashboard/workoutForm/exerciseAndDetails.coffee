class Weightyplates.Models.ExerciseAndDetails extends Backbone.Model

  defaults:
    detailViews: []
    detailViewsCount: null
    actualDetailViewsCount: 0
    hiddenDetailRemoveButton: null
    weightInputError: false
    recentlyAddedDetailsAssociatedModel: []
    recentlyRemovedDetailsAssociatedModel: null
    signalExerciseForm: -1
    dropDownListError: false
    lastClickDetails: null
    lastClickDetailsCid: null
    signalViewHighlight: -1
    toBeHighlightedDetail: null

