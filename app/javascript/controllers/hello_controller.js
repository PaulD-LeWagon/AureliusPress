import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.innerHTML = `
      <h3>Hello World!</h3>
      <p>Welcome to our application.</p>
      <button onclick="alert('Futue Te Ipsum!')">Click me</button>
    `.trim()
    this.#experimentals()
  }

  #experimentals(){
    // Variable Hoisting
    // var has function level scope
    // let and const have block level scope {...}
    // i.e. Can be accessed from within the curly braces that they are defined
    // or any nested blocks therein!
    const test = true
    console.log(one) // Hoisted to the top and set to undefined
    // console.log(two) // Throws ReferenceError
    // console.log(three) // Throws ReferenceError
    if (test) {
      console.log(one) // undefined
      // console.log(two) // ReferenceError
      // console.log(three) // ReferenceError
      var one = 1
      let two = 2
      const three = 3
      console.log(one, two, three) // 1, 2, 3
    }
    console.log(one) // 1
    // console.log(one, two) // ReferenceError
    // console.log(three) // ReferenceError
  }
}
