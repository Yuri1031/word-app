import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share"
export default class extends Controller {
  connect() {
    console.log("share controller connected");
  }

  static targets = ["dropdown"]

  toggle() {
    this.dropdownTarget.classList.toggle("hidden")
  }
}
