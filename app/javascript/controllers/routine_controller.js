import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['empty', 'destroy', 'workoutend']

  addWorkout(event) {
    this.workoutendTarget.insertAdjacentHTML('beforebegin', this.workoutFields)
  }

  get workoutFields() {
    // The exact index doesn't matter, only that it is unique and increasing for each element
    return this.emptyTarget.innerHTML.replace(/NEW_WORKOUT/g, new Date().getTime())
  }
}
