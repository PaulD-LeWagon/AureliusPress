import { describe, it, expect, beforeEach, vi } from 'vitest'
import { mountController } from '../support/stimulus_helper'
import SocialEngagementController from '../../../app/javascript/controllers/social_engagement_controller'

describe('SocialEngagementController', () => {
  let application

  const html = `
    <div data-controller="social-engagement">
      <button data-action="click->social-engagement#togglePicker">Toggle</button>
      <div data-social-engagement-target="picker" class="picker hidden">
        <a href="#" data-action="click->social-engagement#submitReaction">Emoji</a>
      </div>
    </div>
  `

  beforeEach(() => {
    application = mountController('social-engagement', SocialEngagementController, html)
  })

  it('toggles the picker visibility', () => {
    const button = document.querySelector('button')
    const picker = document.querySelector('.picker')

    expect(picker.classList.contains('visible')).toBe(false)

    button.click()
    expect(picker.classList.contains('visible')).toBe(true)

    button.click()
    expect(picker.classList.contains('visible')).toBe(false)
  })

  it('hides the picker when clicking outside', () => {
    const button = document.querySelector('button')
    const picker = document.querySelector('.picker')

    button.click() // Show it
    expect(picker.classList.contains('visible')).toBe(true)

    // Click outside
    document.body.click()
    expect(picker.classList.contains('visible')).toBe(false)
  })

  it('hides the picker on submit', () => {
    const button = document.querySelector('button')
    const picker = document.querySelector('.picker')
    const emojiLink = document.querySelector('a')

    button.click() // Show it
    expect(picker.classList.contains('visible')).toBe(true)

    emojiLink.click()
    expect(picker.classList.contains('visible')).toBe(false)
  })
})
