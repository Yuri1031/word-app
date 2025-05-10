import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="click-answer"
export default class extends Controller {
  static targets = ["answer"]

  toggle(event) {
    const fromStudy = this.element.dataset.fromStudy === "true";
    if (!fromStudy) return;
  
    const answer = this.answerTargets.find(el => {
      return el.dataset.wordId === event.currentTarget.dataset.wordId;
    });
  
    if (answer) {
      answer.style.display = answer.style.display === "none" ? "block" : "none";
    }
  }
}
