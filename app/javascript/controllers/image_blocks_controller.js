import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-blocks"
export default class extends Controller {
  connect() {}

  toggleLinkFields(event) {
    event.preventDefault()
    this.element.querySelector(".link-fields").classList.toggle("hide")
  }
}
