import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['timer', 'time'];

  static values = { soundUrl: String };

  connect() {
    this.timer = null;
    this.seconds = 0;
  }

  startTimer(event) {
    let {reps, target} = event.detail;
    clearTimeout(this.timer);

    if (reps === target) {
      this.seconds = 90;
    } else {
      this.seconds = 60*5;
    }

    this.timeTarget.innerHTML = this.#formatTime(this.seconds);
    this.timerTarget.hidden = false;
    this.timer = setInterval(() => {
      this.seconds -= 1;
      this.timeTarget.innerText = this.#formatTime(this.seconds);

      if (this.seconds === 0) {
        clearInterval(this.timer);
        this.timerTarget.hidden = true;
        this.dispatch("restComplete");

        const audio = new Audio(this.soundUrlValue);
        audio.play();
      }
    }, 1000);
  }

  #formatTime(seconds) {
    let minutes = Math.floor(seconds / 60);
    seconds = (seconds % 60).toString().padStart(2, "0");

    return `${minutes}:${seconds}`;
  }
}
