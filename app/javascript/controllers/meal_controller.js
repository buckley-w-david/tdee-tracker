import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['food', 'add', 'empty', 'foodend', 'destroy']

  addFood(event) {
    this.foodendTarget.insertAdjacentHTML('beforebegin', this.foodFields)
  }

  removeFood(event) {
    const food = event.target.closest('.food');
    const idInput = food.firstElementChild;

    if (idInput.value !== '') {
      food.querySelector('.destroy').value = '1';
      food.hidden = true;
    } else {
      food.remove();
    }
  }

  get foodFields() {
    // The exact index doesn't matter, only that it is unique and increasing for each element
    return this.emptyTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
  }
}
