import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-slugify"
export default class extends Controller {
  static targets = ["source", "slug"]
  connect() {
    console.log("Auto Slugify Controller Connected")
  }

  slugify() {
    if (this.hasSourceTarget && this.hasSlugTarget) {
      this.slugTarget.value = this.sourceTarget.value
        .toLowerCase()
        .trim()
        .replace(/ /g, "-")
        .replace(/[^\w-]+/g, "")
        .replace(/-{2,}/g, "-") // Remove double dashes
    }
  }
}
