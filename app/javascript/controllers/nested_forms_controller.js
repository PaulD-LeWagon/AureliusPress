import NestedForm from "stimulus-rails-nested-form"

export default class extends NestedForm {
  static targets = ["position", "template", "contentBlock", "fieldsContainer"]

  connect() {
    setTimeout(() => {
      super.connect()
      this.#resetPositionOrder()
    }, 10)
  }

  add(event) {
    event.preventDefault()
    const templateName = event.currentTarget.dataset.nestedFormsName
    const template = this.templateTargets.find(
      (t) => t.dataset.nestedFormsName === templateName
    )
    const newFields = template.content.cloneNode(true)
    const tempDiv = document.createElement("div")
    tempDiv.appendChild(newFields)
    const newHtml = tempDiv.innerHTML.replace(
      /NEW_RECORD/g,
      new Date().getTime()
    )
    this.targetTarget.insertAdjacentHTML("beforebegin", newHtml)
    this.#resetPositionOrder()
  }

  remove(event) {
    event.preventDefault()
    super.remove(event)
    this.#resetPositionOrder()
  }

  #resetPositionOrder() {
    this.positionTargets.forEach((cbPosition, index) => {
      cbPosition.dataset.nestedFormsIndex = index
      cbPosition.value = index + 1
    })
  }
}
