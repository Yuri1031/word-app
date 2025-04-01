import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  markCorrect(event) {
    this.updateReviewDate(event.target, false);
  }

  markWrong(event) {
    this.updateReviewDate(event.target, true);
  }

  updateReviewDate(button, isWrong) {
    const wordId = button.dataset.wordId;
    
    fetch(`/word_marks/${wordId}/update_review_date`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ wrong: isWrong })
    })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert(`次の復習日は ${data.review_date} です`);
          this.updateButtonStyles(button, isWrong);
        }
      });
  }

  updateButtonStyles(button, isWrong) {
    document.querySelectorAll(".mark-button").forEach(btn => btn.classList.remove("selected", "correct-selected", "wrong-selected"));
    
    if (isWrong) {
      button.classList.add("selected", "wrong-selected");
    } else {
      button.classList.add("selected", "correct-selected");
    }
  }
}
