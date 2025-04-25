import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "suggestions", "results"]

  initialize() {
    this.timeout = null
  }

  connect() {
    console.log("search controller connected");
  
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
  
    this.inputTarget.addEventListener("input", () => {
      clearTimeout(this.timeout)
      this.timeout = setTimeout(() => {
        this.fetchSuggestions()
      }, 300)
    })
  
    this.element.querySelector("form").addEventListener("submit", (event) => {
      event.preventDefault()
      this.fetchResults()
    })
  }
  
  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }
  
  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.classList.add("hidden")
    }
  }

  fetchSuggestions() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.suggestionsTarget.innerHTML = ""
      return
    }

    fetch(`/searches/suggestions?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.suggestionsTarget.innerHTML = ""
        data.forEach(suggestion => {
          const item = document.createElement("li")
          item.textContent = suggestion
          item.addEventListener("click", () => {
            this.inputTarget.value = suggestion
            this.fetchResults()
          })
          this.suggestionsTarget.appendChild(item)
        })
      })
      .catch(error => console.error("Suggestions error:", error))
  }

  fetchResults() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.resultsTarget.classList.add("hidden") 
      this.resultsTarget.innerHTML = ""
      return
    }
  
    fetch(`/searches/search.json?q[keyword]=${encodeURIComponent(query)}`)
      .then(res => res.json())
      .then(data => {
        this.resultsTarget.innerHTML = this.renderResults(data)
        this.resultsTarget.classList.remove("hidden") 
      })
      .catch(error => {
        console.error("Results fetch error:", error)
        this.resultsTarget.innerHTML = "<p>エラーが発生しました</p>"
        this.resultsTarget.classList.remove("hidden")
      })
  }  

  renderResults(data) {
    let html = ""
    let hasResults = false
  
    if (Array.isArray(data.users) && data.users.length > 0) {
      hasResults = true
      html += "<h3>ユーザー</h3><ul>"
      data.users.forEach(user => {
        html += `<li><a href="/users/${user.id}">${user.nickname}</a></li>`
      })
      html += "</ul>"
    }
  
    if (Array.isArray(data.words) && data.words.length > 0) {
      hasResults = true
      html += "<h3>単語</h3><ul>"
      data.words.forEach(word => {
        html += `<li><a href="/words/${word.id}">${word.title || word.question}</a></li>`
      })
      html += "</ul>"
    }
  
    if (Array.isArray(data.categories) && data.categories.length > 0) {
      hasResults = true
      html += "<h3>カテゴリ</h3><ul>"
      data.categories.forEach(cat => {
        html += `<li><a href="/categories/${cat.id}">${cat.category_name}</a></li>`
      })
      html += "</ul>"
    }
  
    if (Array.isArray(data.groups) && data.groups.length > 0) {
      hasResults = true
      html += "<h3>グループ</h3><ul>"
      data.groups.forEach(group => {
        html += `<li><a href="/groups/${group.id}">${group.group_name}</a></li>`
      })
      html += "</ul>"
    }
  
    if (!hasResults) {
      html = "<p>一致する結果がありません</p>"
    }
  
    return html
  }  
}
