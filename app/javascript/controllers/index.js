// Import and register all your controllers from the importmap via controllers/**/*_controller
// import { application } from "controllers/application"
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("controllers", application)
// "build": "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets"
// import { Application } from "@hotwired/stimulus"
// import { registerControllers } from "stimulus-vite-helpers"
// window.Stimulus = Application.start()
// const controllers = import.meta.glob("./**/*_controller.js", { eager: true })
// registerControllers(window.Stimulus, controllers)
import { Application } from "@hotwired/stimulus"
import HelloController from "./hello_controller"
// import UsersController from "./users_controller"
// import MyOtherController from "./my_other_controller"
window.Stimulus = Application.start()
window.Stimulus.register("hello", HelloController)
// window.Stimulus.register("users", UsersController)
// window.Stimulus.register("my-other", MyOtherController)
