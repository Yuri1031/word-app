import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("menu controller connected")
    document.addEventListener("click", this.closeOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.closeOutsideClick)
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  closeOutsideClick = (event) => {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
