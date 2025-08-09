import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.innerHTML = `
      <h3>Hello World!</h3>
      <p>Welcome to our application.</p>
      <button onclick="alert('Futue Te Ipsum!')">Click me</button>
    `.trim()
  }
}
