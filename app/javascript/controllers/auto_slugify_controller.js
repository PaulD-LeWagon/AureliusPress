import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-slugify"
export default class extends Controller {
  static targets = ["source", "slug"]
  connect() {
    console.log("Auto Slugify Controller Connected")
  }

  onKeyUp(event) {
    this.slugTarget.value = this.sourceTarget.value
      .toLowerCase()
      .replace(/ /g, "-")
      .replace(/[^\w-]+/g, "")
  }
}
