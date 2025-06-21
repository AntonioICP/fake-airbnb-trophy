import { Controller } from "@hotwired/stimulus"

// Native debounce
function debounce(fn, delay = 300) {
  let t
  return (...args) => {
    clearTimeout(t)
    t = setTimeout(() => fn.apply(this, args), delay)
  }
}

export default class extends Controller {
  static targets = ["input"]

  connect () {
    this.createSuggestionBox()
    this.inputTarget.addEventListener("input", debounce(this.search.bind(this), 300))
  }

  createSuggestionBox () {
    this.box = document.createElement("ul")
    this.box.className = "autocomplete-suggestions list-group"
    this.box.style.display = "none" // 👈 Start hidden
    this.inputTarget.parentNode.classList.add("position-relative")
    this.inputTarget.parentNode.appendChild(this.box)
  }

  async search () {
    const term = this.inputTarget.value.trim()
    if (term.length < 2) {
      this.hideBox()
      return
    }

    const response = await fetch(`/flats/autocomplete?term=${encodeURIComponent(term)}`)
    const suggestions = await response.json()

    if (suggestions.length === 0) {
      this.hideBox()
      return
    }

    this.box.innerHTML = ""
    suggestions.forEach(({ value }) => {
      const li = document.createElement("li")
      li.className = "list-group-item list-group-item-action"
      li.textContent = value
      li.onclick = () => {
        this.inputTarget.value = value
        this.hideBox()
      }
      this.box.appendChild(li)
    })

    this.box.style.display = "block"
  }

  hideBox () {
    this.box.innerHTML = ""
    this.box.style.display = "none"
  }
}
