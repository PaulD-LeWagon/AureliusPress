import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "selection"]
  static values = { url: String, createUrl: String }

  connect() {
    this.timeout = null
    this.element.dataset.stimulusConnected = "true"
  }

  search() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.hideResults()
      return
    }

    this.timeout = setTimeout(() => {
      this.fetchResults(query)
    }, 300)
  }

  async fetchResults(query) {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
      headers: { 
        "Accept": "application/json",
        "X-Requested-With": "XMLHttpRequest"
      },
      credentials: "include"
    })
    const tags = await response.json()
    this.renderResults(tags)
  }

  renderResults(tags) {
    this.resultsTarget.innerHTML = ""
    if (tags.length === 0) {
      this.resultsTarget.innerHTML = '<div class="search-result-item no-results">No matches found. Hit Enter to create.</div>'
    } else {
      tags.forEach(tag => {
        const div = document.createElement("div")
        div.className = "search-result-item"
        div.textContent = tag.name
        div.dataset.action = "click->taxonomy-search#select"
        div.dataset.id = tag.id
        div.dataset.name = tag.name
        this.resultsTarget.appendChild(div)
      })
    }
    this.resultsTarget.classList.remove("hidden")
  }

  select(event) {
    const { id, name } = event.currentTarget.dataset
    this.addSelection(id, name)
    this.hideResults()
    this.inputTarget.value = ""
  }

  async create(event) {
    if (event.type === "keydown") {
      const isEnter = event.key === "Enter" || event.keyCode === 13 || event.which === 13
      if (!isEnter) return
      event.preventDefault()
    }
    
    event.stopPropagation()
    const name = this.inputTarget.value.trim()
    if (!name || name.length < 1) return

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    try {
      const response = await fetch(this.createUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": csrfToken
        },
        credentials: "include",
        body: JSON.stringify({ tag: { name: name } })
      })

      if (response.ok) {
        const tag = await response.json()
        this.addSelection(tag.id, tag.name)
        this.inputTarget.value = ""
        this.hideResults()
      } else {
        const errorData = await response.json()
        console.error("Create failed", errorData)
      }
    } catch (err) {
      console.error("Fetch error", err)
    }
  }

  addSelection(id, name) {
    // Avoid duplicates
    if (this.selectionTarget.querySelector(`[data-id="${id}"]`)) return

    const attributeName = this.element.querySelector('input[type="hidden"]')?.name || "document[tag_ids][]"
    const item = document.createElement("div")
    item.className = "selection-item"
    item.dataset.id = id
    item.innerHTML = `
      ${name}
      <input type="hidden" name="${attributeName}" value="${id}">
      <span class="remove" data-action="click->taxonomy-search#remove">&times;</span>
    `
    this.selectionTarget.appendChild(item)
  }

  remove(event) {
    event.currentTarget.closest(".selection-item").remove()
  }

  hideResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
  }
}
