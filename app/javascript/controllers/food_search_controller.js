import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'input',
    'results',
    'foodId', 'foodName', 'foodEnergy', 'foodQuantity', 'foodUnit',
    'foodInit'
  ]

  suggestion(event) {
    const query = this.inputTarget.value;

    if (this.resultsTarget.dataset.query === query) return;

    this.foodIdTarget.value = null;
    this.foodEnergyTarget.value = null;
    this.foodQuantityTarget.value = null;
    this.foodInitTarget.hidden = false;

    if (query.length < 3) return;

    this.resultsTarget.hidden = true;

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      fetch(
        this.element.dataset.suggestionUrl,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ query })
        }
      )
        .then(response => response.text())
        .then(html => {
          this.resultsTarget.dataset.query = query;
          this.resultsTarget.innerHTML = html
          if (this.inputTarget === document.activeElement) {
            this.resultsTarget.hidden = false;
          }
        });
    }, 500);
  }

  selectFood(event) {
    event.preventDefault();
    event.stopPropagation();

    let selection = event.currentTarget;
    this.inputTarget.value = selection.dataset.foodName;

    this.foodIdTarget.value = selection.dataset.foodId;
    this.foodEnergyTarget.value = selection.dataset.foodEnergy;
    this.foodQuantityTarget.value = selection.dataset.foodQuantity;
    this.foodUnitTarget.querySelector(`option[value="${selection.dataset.foodUnit}"]`).selected = true;

    // Other controllers care about when the unit changes
    var event = new Event('change');
    this.foodUnitTarget.dispatchEvent(event);

    this.resultsTarget.hidden = true;
    this.foodInitTarget.hidden = true;
  }

  hideResults(event) {
    if (this.resultsTarget.contains(document.activeElement) || document.activeElement === this.inputTarget) {
      return;
    }
    this.resultsTarget.hidden = true;
  }

  showResults(event) {
    if (this.resultsTarget.innerHTML.length > 0) {
      this.resultsTarget.hidden = false;
    }
  }
}
