class Weightyplates.Models.ExerciseAndDetails extends Backbone.Model

  defaults:
    utilityFunction: null
    detailViews: []
    detailViewsCount: null
    actualDetailViewsCount: 0
    hiddenDetailRemoveButton: null
    weightInputError: false
    recentlyAddedDetailsAssociatedModel: []
    recentlyAddedDetailsAssociatedModelId: null
    recentlyAddedDetailsViewId: null
    recentlyRemovedDetailsAssociatedModel: null
    recentlyRemovedDetailsAssociatedModelId: null
    recentlyRemovedDetailsViewId: null
    recentDetailsViewAction: null
    detailsViewIndex: []
    signalExerciseForm: -1
    dropDownListError: false
    lastClickDetails: null
    lastClickDetailsCid: null
    signalViewHighlight: -1
    toBeHighlightedDetail: null
    focusedInputWhenDragged: false
    classNameOfInputFocus: null

