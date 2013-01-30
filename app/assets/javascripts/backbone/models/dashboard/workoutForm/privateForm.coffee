class Weightyplates.Models.PrivateForm extends Backbone.Model

  defaults:
    lastFocusedInputEvent: null
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


