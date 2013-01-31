class Weightyplates.Models.PrivateForm extends Backbone.Model

  defaults:
    lastFocusedInputEvent: null
    successfullyTriggerByDetails: null
    closeButtonConfirmationMsg:
      change: "A change has been made, exit right not without saving?"
      changes: "Changes have been made, exit right now without saving?"
    saveWorkoutMsg:
      ok: "Good to go, no errors or missing fields."
      errorsAndUnfills: "Errors and unfilled fields prevented submitting."
      errorAndUnfills: "An error and unfilled fields prevented submitting."
      errorsAndUnfill: "Errors and unfilled field prevented submitting."
      oneError: "There is an error on a field."
      manyErrors: "There are many fields with errors."
      missingField: "Please fill in missing field before submitting."
      missingFields: "Please fill in missing fields before submitting."

  checkErrorsAndUnfilled: (associatedModels, workoutEntryLength) ->
    i = 0
    missingExerciseFieldCount = 0
    missingDetailFieldCount = 0
    dateInExerciseFieldCount = 0
    dateInDetailFieldCount = 0
    invalidWeightCount = 0
    invalidrepCount = 0
    exerciseCount = 0
    detailCount = 0

    while i <= workoutEntryLength - 1
      exerciseVal = associatedModels.at(i).get("exercise_id")

      #no errors are possible for exercise because valid options are chosen from the list
      #checking for 0, which corresponds with no input for exercise
      if !_.isNull(exerciseVal) and !_.isUndefined(exerciseVal) and exerciseVal == 0
        missingExerciseFieldCount++

      #exercise counter
      ++exerciseCount

      entryDetailLength = associatedModels.at(i).get("entry_detail").length
      entryDetailModel = associatedModels.at(i).get("entry_detail")

      j = 0
      while j <= entryDetailLength - 1
        #get the weight and rep values
        weightVal = entryDetailModel.at(j).get("weight")
        repVal = entryDetailModel.at(j).get("reps")

        #details counter
        detailCount += 2

        #check for field errors
        if entryDetailModel.at(j).get("invalidWeight")
          ++invalidWeightCount

        if entryDetailModel.at(j).get("invalidRep")
          ++invalidrepCount

        #check for missing inputs
        if _.isNull(weightVal) and !_.isUndefined(weightVal) and !entryDetailModel.at(j).get("invalidWeight")
          missingDetailFieldCount++

        if _.isNull(repVal) and !_.isUndefined(repVal) and !entryDetailModel.at(j).get("invalidRep")
          missingDetailFieldCount++

        j++

      i++

      totalFieldErrors = invalidWeightCount + invalidrepCount
      totalFields = exerciseCount + detailCount
      totalUnFilledFields = missingExerciseFieldCount + missingDetailFieldCount

      {totalFieldErrors: totalFieldErrors, totalFields: totalFields, totalUnFilledFields: totalUnFilledFields}





