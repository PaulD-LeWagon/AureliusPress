import { Application } from '@hotwired/stimulus'

let application

export function mountController(identifier, ControllerClass, html) {
  if (!application) {
    application = Application.start()
  }

  application.register(identifier, ControllerClass)
  document.body.innerHTML = html
  return application
}

export function clearApplication() {
  if (application) {
    application.stop()
    application = undefined
  }
  document.body.innerHTML = ''
}

export function getController(element, identifier) {
  // Stimulus 3+ uses the application instance to find controllers
  // For unit tests, we'll often just query the element directly if needed
  // but this helper can be expanded as we find patterns.
}
