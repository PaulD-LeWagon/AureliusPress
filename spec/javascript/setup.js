import { afterEach, vi } from 'vitest'
import '@testing-library/jest-dom'
import { clearApplication } from './support/stimulus_helper'

// Polyfill Node and HTMLElement for Stimulus in JSDOM
if (typeof global.Node === 'undefined') {
  global.Node = window.Node
  global.HTMLElement = window.HTMLElement
  global.MutationObserver = window.MutationObserver
}

// Runs a cleanup after each test case
afterEach(() => {
  clearApplication()
  vi.clearAllMocks()
})
