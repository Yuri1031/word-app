/////// modal //////
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect(){
    console.log("modal controller connected");
  }
  

  open() {
    console.log("modal open")
    this.modalTarget.style.display = "block"
  }

  close() {
    console.log("modal close")
    this.modalTarget.style.display = "none"
  }
}
