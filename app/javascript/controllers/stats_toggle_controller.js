import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'label' ]

  initialize() {
    this.state = false;
  }

  toggle() {
    this.state = !this.state;
    let url = this.state ? `/stats?end_date=${this.#end_date()}` : `/stats?start_date=${this.#start_date()}&end_date=${this.#end_date()}`;

    this.labelTarget.innerText = this.state ? 'All time' : 'Last 45 days';
    fetch(url, { headers: { Accept: "text/vnd.turbo-stream.html" } })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  #start_date() {
    return this.element.dataset.start_date;
  }

  #end_date() {
    return this.element.dataset.end_date;
  }
}
