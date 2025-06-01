import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hover-color"
export default class extends Controller {
  static targets = ["logout"]

  connect() {
    this.originalColor = this.logoutTarget.style.backgroundColor
    this.userColor = this.logoutTarget.dataset.userColor || "#f0f0f0"

    this.logoutTarget.addEventListener("mouseenter", () => {
      this.logoutTarget.style.backgroundColor = this.userColor
    })

    this.logoutTarget.addEventListener("mouseleave", () => {
      this.logoutTarget.style.backgroundColor = this.originalColor
    })
  }
}
