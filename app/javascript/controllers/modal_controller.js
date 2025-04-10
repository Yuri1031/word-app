/////// modal //////
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  

  open() {
    console.log('modal open!');
    this.modalTarget.style.display = "block"

    console.log('search_result clear!');
    
    document.getElementById('search_result').innerHTML = '';
    const form = document.getElementById('friend_search_form');
    if (form) {
        form.reset();
    }
  }

  close() {
    this.modalTarget.style.display = "none"
    const form = document.getElementById('friend_search_form');
    if (form) {
      form.reset();
      document.getElementById('search_result').innerHTML = ''; 
    }
    document.getElementById('modal_close_button').addEventListener('click', this.close.bind(this));
  }
}
