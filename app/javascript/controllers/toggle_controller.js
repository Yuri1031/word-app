import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["checkbox", "label"]
  
  connect() {
    console.log("toggle controller connected");
    this.updateStyle() 
  }

  toggle() {
    const wordId = this.checkboxTarget.dataset.wordId

    fetch(`/words/${wordId}/word_marks/toggle`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        "Content-Type": "application/json"
      },
      body: JSON.stringify({})
    })
      .then(res => res.json())
      .then(data => {
        this.updateStyle(data.dif)
      })
      .catch(err => console.error("Toggle failed:", err))
  }

  updateStyle(dif = null) {
    const isChecked = dif !== null ? dif === 1 : this.checkboxTarget.checked

    if (isChecked) {
      this.labelTarget.classList.add("active")
    } else {
      this.labelTarget.classList.remove("active")
    }
  }
}