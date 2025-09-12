import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "message", "confirmBtn", "cancelBtn"]

  connect() {
    console.log("Delete confirmation controller connected")
    console.log("Modal target exists:", this.hasModalTarget)
    if (this.hasModalTarget) {
      console.log("Modal element:", this.modalTarget)
      console.log("Modal classes:", this.modalTarget.className)
    }
  }

  show(event) {
    try {
      console.log("Delete confirmation show method called")
      event.preventDefault()
      
      // Get the delete URL and message from the clicked element
      const deleteButton = event.currentTarget
      const url = deleteButton.dataset.deleteUrl
      const message = deleteButton.dataset.deleteMessage
      
      console.log("URL:", url, "Message:", message)
      
      // Debug: Check if modal element exists in DOM
      console.log("Looking for modal element...")
      const modalElement = document.querySelector('[data-delete-confirmation-target="modal"]')
      console.log("Modal element found in DOM:", modalElement)
      
      if (modalElement) {
        console.log("Modal element classes:", modalElement.className)
        console.log("Modal element style:", modalElement.style.display)
        
        // Test: Try to make modal visible manually
        console.log("Testing manual modal visibility...")
        modalElement.classList.remove("hidden")
        console.log("Modal classes after manual removal:", modalElement.className)
        console.log("Modal should now be visible manually")
      } else {
        console.log("ERROR: Modal element not found in DOM!")
        console.log("Available elements with data-delete-confirmation-target:", 
          document.querySelectorAll('[data-delete-confirmation-target]'))
      }
    
    // Update modal content
    console.log("Checking message target...")
    if (this.hasMessageTarget) {
      console.log("Message target found, updating text")
      this.messageTarget.textContent = message
    } else {
      console.log("No message target found!")
    }
    
    console.log("Checking confirm button target...")
    if (this.hasConfirmBtnTarget) {
      console.log("Confirm button target found, setting URL")
      this.confirmBtnTarget.dataset.url = url
    } else {
      console.log("No confirm button target found!")
    }
    
    // Show modal
    if (this.hasModalTarget) {
      console.log("Modal target found, removing hidden class")
      console.log("Modal element:", this.modalTarget)
      console.log("Modal classes before:", this.modalTarget.className)
      this.modalTarget.classList.remove("hidden")
      console.log("Modal classes after:", this.modalTarget.className)
      document.body.classList.add("overflow-hidden")
      console.log("Modal should now be visible")
      
      // Additional debugging for modal visibility
      console.log("Modal computed style display:", window.getComputedStyle(this.modalTarget).display)
      console.log("Modal computed style visibility:", window.getComputedStyle(this.modalTarget).visibility)
      console.log("Modal computed style opacity:", window.getComputedStyle(this.modalTarget).opacity)
      console.log("Modal offsetHeight:", this.modalTarget.offsetHeight)
      console.log("Modal offsetWidth:", this.modalTarget.offsetWidth)
      
      // Check modal content
      const modalContent = this.modalTarget.querySelector('.bg-white')
      console.log("Modal content element:", modalContent)
      if (modalContent) {
        console.log("Modal content classes:", modalContent.className)
        console.log("Modal content offsetHeight:", modalContent.offsetHeight)
      }
    } else {
      console.log("No modal target found!")
    }
    } catch (error) {
      console.error("Error in show method:", error)
    }
  }

  hideModal() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }
  }

  confirmDelete(event) {
    const url = event.currentTarget.dataset.url
    
    // Create a form to submit the delete request
    const form = document.createElement("form")
    form.method = "POST"
    form.action = url
    
    // Add CSRF token
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
    const csrfInput = document.createElement("input")
    csrfInput.type = "hidden"
    csrfInput.name = "authenticity_token"
    csrfInput.value = csrfToken
    form.appendChild(csrfInput)
    
    // Add method override for DELETE
    const methodInput = document.createElement("input")
    methodInput.type = "hidden"
    methodInput.name = "_method"
    methodInput.value = "DELETE"
    form.appendChild(methodInput)
    
    // Submit the form
    document.body.appendChild(form)
    form.submit()
  }
}