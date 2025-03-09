import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['empty', 'destroy', 'setend', 'setplan']

  initialize() {
    this.count = 0;
  }

  addSet(event) {
    this.setendTarget.insertAdjacentHTML('beforebegin', this.setFields)

    if (this.count > 0) {
      this.setplanTargets[this.count].querySelector('.weight').value = this.setplanTargets[this.count - 1].querySelector('.weight').value
      this.setplanTargets[this.count].querySelector('.reps').value = this.setplanTargets[this.count - 1].querySelector('.reps').value
    }

    this.count++
  }

  removeSetPlan(event) {
    const setPlan = event.target.closest(".set-plan");
    const idInput = setPlan.firstElementChild;

    if (idInput.value !== "") {
      setPlan.hidden = true;
      let clone = idInput.cloneNode();
      clone.name = clone.name.replace("id", "_destroy")
      clone.value = true;
      setPlan.appendChild(clone);
    } else {
      setPlan.remove();
    }
  }

  get setFields() {
    // The exact index doesn't matter, only that it is unique and increasing for each element
    return this.emptyTarget.innerHTML.replace(/NEW_SET/g, new Date().getTime())
  }
}
