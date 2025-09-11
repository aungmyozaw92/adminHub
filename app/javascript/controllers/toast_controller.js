import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  static values = { 
    type: String,
    message: String,
    duration: { type: Number, default: 5000 }
  }

  connect() {
    console.log("Toast controller connected", this.element)
    console.log("Toast element position:", this.element.getBoundingClientRect())
    console.log("Toast element styles:", window.getComputedStyle(this.element))
    
    // Show the element first
    this.element.style.display = "block"
    
    // Small delay to ensure the element is rendered before animation
    setTimeout(() => {
      this.show()
    }, 10)
  }

  show() {
    console.log("Showing toast", this.toastTarget)
    console.log("Toast target position before:", this.toastTarget.getBoundingClientRect())
    console.log("Toast target styles before:", window.getComputedStyle(this.toastTarget))
    
    // Add show animation
    this.toastTarget.classList.remove("translate-x-full", "opacity-0")
    this.toastTarget.classList.add("translate-x-0", "opacity-100")
    
    // Force visibility
    this.toastTarget.style.display = "block"
    this.toastTarget.style.visibility = "visible"
    this.toastTarget.style.opacity = "1"
    this.toastTarget.style.transform = "translateX(0)"
    
    console.log("Toast target position after:", this.toastTarget.getBoundingClientRect())
    console.log("Toast target styles after:", window.getComputedStyle(this.toastTarget))
    
    // Auto hide after duration
    setTimeout(() => {
      this.hide()
    }, this.durationValue)
  }

  hide() {
    // Add hide animation
    this.toastTarget.classList.remove("translate-x-0", "opacity-100")
    this.toastTarget.classList.add("translate-x-full", "opacity-0")
    
    // Remove element after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  close() {
    this.hide()
  }
}
