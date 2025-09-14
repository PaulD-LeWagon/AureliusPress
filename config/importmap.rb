# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "stimulus-rails-nested-form" # @4.1.0
pin "color" # @5.0.1
pin "color-string" # @2.1.1
pin "color-convert" # @3.1.1
pin "color-name" # @2.0.1
pin "list" # @2.0.19
