import { describe, it, expect, beforeEach } from 'vitest'
import { mountController } from '../support/stimulus_helper'
import AutoSlugifyController from '../../../app/javascript/controllers/auto_slugify_controller'

describe('AutoSlugifyController', () => {
  let application

  const html = `
    <div data-controller="auto-slugify">
      <input type="text" data-auto-slugify-target="source" 
             data-action="keyup->auto-slugify#onKeyUp" id="source">
      <input type="text" data-auto-slugify-target="slug" id="slug">
    </div>
  `

  beforeEach(() => {
    application = mountController('auto-slugify', AutoSlugifyController, html)
  })

  it('slugifies basic text', () => {
    const source = document.getElementById('source')
    const slug = document.getElementById('slug')

    source.value = 'Hello World'
    source.dispatchEvent(new Event('keyup'))

    expect(slug.value).toBe('hello-world')
  })

  it('removes special characters and maintains lowercase', () => {
    const source = document.getElementById('source')
    const slug = document.getElementById('slug')

    source.value = 'My Awesome Post! (2024)'
    source.dispatchEvent(new Event('keyup'))

    expect(slug.value).toBe('my-awesome-post-2024')
  })
})
