import { defineConfig } from 'vitest/config'
import path from 'path'

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./spec/javascript/setup.js'],
    include: ['spec/javascript/**/*_spec.js'],
    alias: {
      '@hotwired/stimulus': path.resolve(__dirname, 'node_modules/@hotwired/stimulus'),
      '@hotwired/turbo': path.resolve(__dirname, 'node_modules/@hotwired/turbo'),
      // Add other aliases here if you have more pinned imports in importmap.rb
    }
  }
})
