import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="categories"
export default class extends Controller {
  static targets = [
    "categorySelect",
    "categorySelectGroup",
    "newCategoryInput",
    "newCategoryGroup",
    "addNewCategoryButton",
    "removeNewCategoryButton",
  ]

  connect() {
    console.log("Categories controller connected")
    const currentCategory =
      this.categorySelectTarget.options[this.categorySelectTarget.selectedIndex]
        .text
    if (currentCategory === this.newCategoryInputTarget.value) {
      this.newCategoryInputTarget.value = ""
    }
    // sel.options[sel.selectedIndex].text
    console.log(currentCategory)
  }

  addNewCategory(event) {
    event.preventDefault()
    console.log("Add New Category button clicked")
    this.categorySelectTarget.options[0].selected = true
    this.categorySelectTarget.setAttribute("disabled", "true")
    this.categorySelectGroupTarget.style.display = "none"
    this.newCategoryGroupTarget.style.display = "block"
    this.addNewCategoryButtonTarget.style.display = "none"
    this.removeNewCategoryButtonTarget.style.display = "inline-block"
    this.newCategoryInputTarget.removeAttribute("disabled")
    this.newCategoryInputTarget.focus()
  }

  removeNewCategory(event) {
    event.preventDefault()
    console.log("Remove New Category button clicked")
    this.newCategoryInputTarget.value = ""
    this.newCategoryInputTarget.setAttribute("disabled", "true")
    this.categorySelectTarget.removeAttribute("disabled")
    this.categorySelectGroupTarget.style.display = "block"
    this.newCategoryGroupTarget.style.display = "none"
    this.addNewCategoryButtonTarget.style.display = "inline-block"
    this.removeNewCategoryButtonTarget.style.display = "none"
    this.categorySelectTarget.focus()
  }
}
