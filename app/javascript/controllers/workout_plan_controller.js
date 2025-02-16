import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['empty', 'destroy', 'exerciseend']

  addWorkout(event) {
    this.exerciseendTarget.insertAdjacentHTML('beforebegin', this.exerciseFields)
  }

  get exerciseFields() {
    // The exact index doesn't matter, only that it is unique and increasing for each element
    return this.emptyTarget.innerHTML.replace(/NEW_EXCERCISE/g, new Date().getTime())
  }
}
