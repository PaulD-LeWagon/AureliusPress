import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker"]

  connect() {
    console.log("Engagement controller connected")
    this.boundHandleOutsideClick = this.handleOutsideClick.bind(this)
  }

  togglePicker(event) {
    console.log("Toggle picker clicked")
    event.preventDefault()
    event.stopPropagation()
    this.pickerTarget.classList.toggle("visible")

    if (this.pickerTarget.classList.contains("visible")) {
      document.addEventListener("click", this.boundHandleOutsideClick)
    } else {
      document.removeEventListener("click", this.boundHandleOutsideClick)
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.hidePicker()
    }
  }

  hidePicker() {
    this.pickerTarget.classList.remove("visible")
    document.removeEventListener("click", this.boundHandleOutsideClick)
  }

  submitReaction(event) {
    // The link/button in the picker automatically submits as a Turbo request
    // We just need to hide the picker.
    this.hidePicker()
  }

  disconnect() {
    document.removeEventListener("click", this.boundHandleOutsideClick)
  }
}
