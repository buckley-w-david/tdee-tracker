import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['reps', 'display'];
  static values = { targetReps: Number };

  logReps(event) {
    if (this.repsTarget.value === "" || this.repsTarget.value === "0") {
      this.repsTarget.value = this.targetRepsValue;
    } else {
      this.repsTarget.value = Number(this.repsTarget.value) - 1;
    }

    this.displayTarget.innerText = this.repsTarget.value;
    this.displayTarget.classList.remove('text-secondary');

    this.dispatch("setComplete", { detail: { reps: Number(this.repsTarget.value), target: this.targetRepsValue }});
  }
}
