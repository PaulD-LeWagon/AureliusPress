import { describe, it, expect, beforeEach, vi } from 'vitest'
import { mountController } from '../support/stimulus_helper'
import TaxonomySearchController from '../../../app/javascript/controllers/taxonomy_search_controller'

describe('TaxonomySearchController', () => {
  let application

  const html = `
    <div data-controller="taxonomy-search" 
         data-taxonomy-search-url-value="/api/tags"
         data-taxonomy-search-create-url-value="/api/tags/create">
      <input type="text" data-taxonomy-search-target="input" data-action="input->taxonomy-search#search keydown->taxonomy-search#create">
      <div data-taxonomy-search-target="results" class="hidden"></div>
      <div data-taxonomy-search-target="selection"></div>
    </div>
  `

  beforeEach(() => {
    vi.stubGlobal('fetch', vi.fn())
    application = mountController('taxonomy-search', TaxonomySearchController, html)
  })

  it('connects and sets the diagnostic attribute', () => {
    const element = document.querySelector('[data-controller="taxonomy-search"]')
    expect(element.dataset.stimulusConnected).toBe('true')
  })

  it('fetches results after typing (debounced)', async () => {
    const input = document.querySelector('[data-taxonomy-search-target="input"]')
    
    // Mock the response
    fetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([{ id: 1, name: 'Ruby' }])
    })

    // Simulate typing
    input.value = 'Rub'
    input.dispatchEvent(new Event('input'))

    // Wait for debounce (300ms + buffer)
    await new Promise(resolve => setTimeout(resolve, 350))

    expect(fetch).toHaveBeenCalledWith(
      expect.stringContaining('/api/tags?q=Rub'),
      expect.objectContaining({
        headers: expect.objectContaining({
          'X-Requested-With': 'XMLHttpRequest'
        }),
        credentials: 'include'
      })
    )

    const results = document.querySelector('[data-taxonomy-search-target="results"]')
    expect(results.innerHTML).toContain('Ruby')
    expect(results.classList.contains('hidden')).toBe(false)
  })

  it('adds a selection when a result is clicked', async () => {
    const controllerElement = document.querySelector('[data-controller="taxonomy-search"]')
    const selection = document.querySelector('[data-taxonomy-search-target="selection"]')

    // We need to get the controller instance from the application
    const controller = application.getControllerForElementAndIdentifier(controllerElement, 'taxonomy-search')
    
    // Trigger renderResults through the controller
    controller.renderResults([{ id: '1', name: 'Ruby' }])

    const results = document.querySelector('[data-taxonomy-search-target="results"]')
    const item = results.querySelector('.search-result-item')
    
    // Stimulus actions are connected on the next tick after a DOM change
    await new Promise(resolve => setTimeout(resolve, 0))
    
    item.click()

    expect(selection.innerHTML).toContain('Ruby')
    expect(selection.querySelector('input[type="hidden"]').value).toBe('1')
    expect(results.innerHTML).toBe('') // Should be cleared after selection
  })
})
