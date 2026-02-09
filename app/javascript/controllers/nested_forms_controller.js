import NestedForm from "stimulus-rails-nested-form"

export default class extends NestedForm {
  static targets = ["position"]

  connect() {
    setTimeout(() => {
      super.connect()
      this.#resetPositionOrder()
    }, 10)
  }

  add(event) {
    event.preventDefault()

    const targetName = event.currentTarget.dataset.nestedFormsTargetName
    const target = this.targetTargets.find(
      (t) => t.dataset.nestedFormsTargetName === targetName
    )
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
    target.insertAdjacentHTML("beforebegin", newHtml)
    this.#resetPositionOrder()
  }

  remove(event) {
    event.preventDefault()
    super.remove(event)
    this.#resetPositionOrder()
  }

  #resetPositionOrder() {
    if (this.positionTargets.length === 0) return
    this.positionTargets.forEach((cbPosition, index) => {
      cbPosition.dataset.nestedFormsIndex = index
      cbPosition.value = index + 1
    })
  }
}
