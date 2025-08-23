import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="document-meta"
export default class extends Controller {
  static targets = ["statusSelect", "publishedAt"]
  connect() {
    console.log("Document Meta Controller connected")
  }

  onStatusChange() {
    const statusSelect = this.statusSelectTarget
    const status = statusSelect.value
    const publishedAtSelect = this.publishedAtTarget
    const publishedAt = publishedAtSelect.value

    if (status === "draft") {
      // Reset publishedAt field
      publishedAtSelect.value = ""
      // Ensure the publishedAt field is readonly
      if (this.#isNotReadOnly(publishedAtSelect)) {
        publishedAtSelect.setAttribute("readonly", true)
      }
    } else if (status === "scheduled") {
      // Reset publishedAt field
      publishedAtSelect.value = ""
      // Ensure the publishedAt field is NOT readonly
      if (this.#isReadOnly(publishedAtSelect)) {
        publishedAtSelect.removeAttribute("readonly")
      }
    } else if (status === "published") {
      // Set the current date and time
      publishedAtSelect.value = new Date().toISOString().slice(0, 16)
      // Ensure the publishedAt field is readonly
      if (this.#isNotReadOnly(publishedAtSelect)) {
        publishedAtSelect.setAttribute("readonly", true)
      }
    } else {
      // Catch everything else
      console.log("In catch-all")
      if (!publishedAt) {
        console.log("publishedAt:", publishedAt)
        publishedAtSelect.value = new Date().toISOString().slice(0, 16)
      }
      if (this.#isNotReadOnly(publishedAtSelect)) {
        publishedAtSelect.setAttribute("readonly", true)
      }
    }
  }

  #isReadOnly(element) {
    return element.hasAttribute("readonly")
  }

  #isNotReadOnly(element) {
    return !this.#isReadOnly(element)
  }
}
