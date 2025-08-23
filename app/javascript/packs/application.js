window.initializeTrix = function (element) {
  const input = element.querySelector("trix-editor")
  if (input) {
    new Trix.Editor(input)
  }
}
