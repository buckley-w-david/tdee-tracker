import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'foodUnit', 'entryUnit' ]

  updateUnit(event) {
    const unit = this.foodUnitTarget.value;

    // FIXME: It's inefficient to have to keep parsing this matrix every change
    const compatibilityMatrix = JSON.parse(this.element.dataset.compatibilityMatrix);
    const compatibleUnits = compatibilityMatrix[unit];

    for (let option of this.entryUnitTarget.options) {
      if (compatibleUnits.includes(option.value)) {
        option.disabled = false;

        if (option.value === unit) {
          option.selected = true;
        }
      } else {
        option.disabled = true;
      }
    }
  }
}

