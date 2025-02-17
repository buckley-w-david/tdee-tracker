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

    let seconds;
    if (reps === target) {
      seconds = 90;
    } else {
      seconds = 60*5;
    }

    this.timeTarget.innerHTML = this.#formatTime(this.seconds);
    this.timerTarget.hidden = false;

    const targetTime = Date.now() + seconds * 1000;

    // TODO: Investigate running the timer in a web worker to avoid the timer being paused while the tab is in the background.
    this.timer = setInterval(() => {
      let now = Date.now();
      let timeLeft = Math.round((targetTime - now) / 1000);
      this.timeTarget.innerText = this.#formatTime(timeLeft);

      if (timeLeft <= 0) {
        clearInterval(this.timer);
        this.timerTarget.hidden = true;
        this.dispatch("restComplete");

        const audio = new Audio(this.soundUrlValue);
        audio.play();
      }
    }, 200);
  }

  #formatTime(seconds) {
    let minutes = Math.floor(seconds / 60);
    seconds = (seconds % 60).toString().padStart(2, "0");

    return `${minutes}:${seconds}`;
  }
}
