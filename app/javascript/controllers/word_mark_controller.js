import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="word-mark"
export default class extends Controller {
  static targets = ["correct", "wrong", "answer"]

  connect() {
    console.log("WordMark controller connected")
    console.log("Correct Targets: ", this.correctTargets)
    console.log("Wrong Targets: ", this.wrongTargets)
    const markType = this.element.dataset.markType

    if (markType === "correct") {
      this.correctTargets.forEach(btn => btn.classList.add("correct-selected"))
    } else if (markType === "wrong") {
      this.wrongTargets.forEach(btn => btn.classList.add("wrong-selected"))
    }

    this.correctTargets.forEach(button => {
      button.addEventListener("click", () => this.markCorrect(button))
    })

    this.wrongTargets.forEach(button => {
      button.addEventListener("click", () => this.markWrong(button))
    })
  } 

  markCorrect(button) {
    const wordId = button.dataset.wordId
    this.sendMark(wordId, false)

    button.classList.add("correct-selected")
    const wrongButton = this.wrongTargets.find(btn => btn.dataset.wordId === wordId)
    wrongButton?.classList.remove("wrong-selected")
  }

  markWrong(button) {
    const wordId = button.dataset.wordId
    this.sendMark(wordId, true)

    button.classList.add("wrong-selected")
    const correctButton = this.correctTargets.find(btn => btn.dataset.wordId === wordId)
    correctButton?.classList.remove("correct-selected")
  }

  sendMark(wordId, isWrong) {
    fetch("/word_marks/update_review_date", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ word_id: wordId, wrong: isWrong })
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          const msg = isWrong
            ? "3日後に復習として再表示されます。"
            : "この単語は復習対象から外されました。"
          alert(msg)
      
          const nextUrl = this.element.dataset.wordMarkNextUrl 
          if (nextUrl) {
            Turbo.visit(nextUrl)
          } else {
            alert("すべての単語の復習が完了しました！")
            Turbo.visit("/word_marks")

          }
        }
      })
  }
  toggleAnswer(event) {
    const answer = this.answerTargets.find(ans => ans.dataset.wordId === event.currentTarget.dataset.wordId)
    if (answer) {
      answer.style.display = answer.style.display === "none" ? "block" : "none"
    }
  }
}
