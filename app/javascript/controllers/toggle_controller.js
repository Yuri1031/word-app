import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["checkbox", "label"]
  
  connect() {
    console.log("toggle controller connected");
    this.updateStyle() 
  }

  toggle() {
    console.log("✅ toggle called");
    const tokenTag = document.querySelector('meta[name="csrf-token"]');
    console.log("🔒 token:", tokenTag?.content);
    const wordId = this.checkboxTarget.dataset.wordId;
    const markType = this.checkboxTarget.checked ? 1 : null;  
    
    fetch(`/words/${wordId}/word_marks/toggle`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ mark_type: markType }) 
    })
    .then(res => res.json())
    .then(data => {
      this.updateStyle(data.mark_type);  
    })
    .catch(err => console.error("Toggle failed:", err));
  }

  updateStyle(markType = null) {
    const isChecked = markType !== null ? markType === 1 : this.checkboxTarget.checked

    if (isChecked) {
      this.labelTarget.classList.add("active")
    } else {
      this.labelTarget.classList.remove("active")
    }
  }
}