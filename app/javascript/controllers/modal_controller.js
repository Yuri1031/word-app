/////// modal //////
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  

  open() {
    this.modalTarget.style.display = "block"
    document.getElementById('search_result').innerHTML = '';
  }

  close() {
    this.modalTarget.style.display = "none"
    const form = document.getElementById('friend_search_form');
    if (form) {
      form.reset();
      document.getElementById('search_result').innerHTML = ''; // 検索結果もリセット
    }
  }
}
