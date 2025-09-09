import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const nav = document.querySelector('nav[data-controller="sidebar"]')
    if (!nav) return
    nav.classList.toggle('hidden')
  }
}
